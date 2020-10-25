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

let list ~server ~client =
  server
  |> Server.clients
  |> List.map ~f:Client.to_string
  |> String.concat ~sep:", "
  |> Printf.sprintf "online: %s"
  |> Client.send client

let send ~server ~client (target_id, content) =
  let target =
    match int_of_string_opt target_id with
    | Some id -> Server.find server id
    | None -> None
  in
  match target with
  | None ->
     target_id
     |> Printf.sprintf "User with id %s not found"
     |> Client.send client
  | Some target ->
     let id = Client.to_string client in
     let text = String.concat ~sep:" " content in
     let message = Printf.sprintf "Message from %s: %s" id text in
     Client.send target message

let broadcast ~server ~client content =
  let id = Client.to_string client in
  let text = String.concat ~sep:" " content in
  let msg = Printf.sprintf "%s: %s" id text in
  Server.broadcast_to_others server client msg

let handle ~message server client =
  Logs.app ~src (fun m -> m "[ON_MESSAGE] %s" message);
  match String.split ~on:' ' message with
  | [ "/list" ] ->
     list ~server ~client
  | [ "/quit" ] ->
     Server.close server client
  | "/msg" :: id :: text ->
     send ~server ~client (id, text)
  | content ->
     broadcast ~server ~client content

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
