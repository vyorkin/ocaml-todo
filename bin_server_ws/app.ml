open Core
open Todo_base
open Todo_ws

type params =
  { verbose: bool;
    port: int;
    tls: Server.tls option;
  }

let src =
  Logs.Src.create "todo_server_ws.server"

let init ~verbose =
  let reporter = Log.make_reporter ~verbose in
  Logs.set_reporter reporter

let handle ~message s c =
  Logs.app ~src (fun m -> m "[ON_MESSAGE] %s" message);
  match String.split ~on:'|' message with
  | [ "list" ] ->
     Handler.Todo.list (s, c)
  | "show" :: id :: _ ->
     Handler.Todo.show ~id (s, c)
  | "create" :: data :: _ ->
     Handler.Todo.create ~data (s, c)
  | "update" :: id :: data :: _ ->
     Handler.Todo.update ~id ~data (s, c)
  | "delete" :: id :: _ ->
     Handler.Todo.delete ~id (s, c)
  | _ -> Handler.unknown (s, c)

let on_connect _client =
  Logs.app ~src (fun m -> m "[ON_CONNECT]");
  Lwt.return_unit

let on_close ~reason _client =
  Logs.app ~src (fun m -> m "[ON_CLOSE] reason: %s" reason);
  Lwt.return_unit

let on_error ~exn _client =
  Logs.app ~src (fun m -> m "[ON_ERROR] error: %s" (Exn.to_string exn));
  Lwt.return_unit

let start { verbose; tls; port } =
  init ~verbose;
  let server = Server.make ?tls ~port in
  let on_message = handle server in
  server
  |> Server.start ~on_connect ~on_close ~on_error ~on_message
  |> Lwt_main.run
