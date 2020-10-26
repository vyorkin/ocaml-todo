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

let on_message ~message client =
  let open Handler in
  Logs.app ~src (fun m -> m "[ON_MESSAGE] %s" message);
  match String.split ~on:'|' message with
  | [ "index" ] ->
     Todo.index [] client
  | "show" :: id :: _ ->
     Todo.show [ id ] client
  | "create" :: data :: _ ->
     Todo.create [ data ] client
  | "update" :: id :: data :: _ ->
     Todo.update [ id; data ] client
  | "delete" :: id :: _ ->
     Todo.delete [ id ] client
  | _ ->
     Response.not_found client

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
  server
  |> Server.start ~on_connect ~on_close ~on_error ~on_message
  |> Lwt_main.run
