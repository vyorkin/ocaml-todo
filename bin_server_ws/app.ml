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

let handle ~message server client =
  let module Handler = Handler.Todo in
  Logs.app ~src (fun m -> m "[ON_MESSAGE] %s" message);
  match String.split ~on:'|' message with
  | [ "list" ] ->
     Handler.list (server, client)
  | "show" :: id :: _ ->
     Handler.show ~id (server, client)
  | "create" :: data :: _ ->
     Handler.create ~data (server, client)
  | "update" :: id :: data :: _ ->
     Handler.update ~id ~data (server, client)
  | "delete" :: id :: _ ->
     Handler.delete ~id (server, client)
  | _ -> Response.not_found client

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
