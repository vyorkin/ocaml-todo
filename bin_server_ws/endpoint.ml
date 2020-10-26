open Lwt.Syntax
open Todo_base
open Todo_ws

type t = Client.t -> string list -> unit Lwt.t

let src =
  Logs.Src.create "todo_server_ws.endpoint"

let handle ~of_string ~to_string f content client =
  try
    let* data = of_string content in
    match%lwt f data with
    | Ok result -> to_string result
    | Error _ -> Response.server_error client
  with err ->
    Log.unhandled_error err;
    Response.server_error client

let index of_string to_string =
  Logs.app ~src (fun m -> m "[INDEX]");
  handle

let show _of_string _to_string _ _ =
  Logs.app ~src (fun m -> m "[SHOW] %s" "id");
  Lwt.return_unit

let create _of_string _to_string _ _ =
  Logs.app ~src (fun m -> m "[CREATE] %s" "data");
  Lwt.return_unit

let update _of_string _to_string _ _ _ =
  Logs.app ~src (fun m -> m "[UPDATE] %s %s" "id" "data");
  Lwt.return_unit

let delete _of_string _to_string _ _ =
  Logs.app ~src (fun m -> m "[DELETE] %s" "id");
  Lwt.return_unit
