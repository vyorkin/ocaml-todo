open Lwt.Syntax
open Todo_base
open Todo_ws

type t = Client.t -> string list -> unit Lwt.t

let src =
  Logs.Src.create "todo_server_ws.endpoint"

let handle ~of_json ~to_json f content client =
  Lwt.return_unit
  (* try
   *   let* data = of_json content in
   * with err ->
   *   Log.unhandled_error err;
   *   Response.server_error client *)

let index _of_json _to_json _ _ =
  Logs.app ~src (fun m -> m "[INDEX]");
  Lwt.return_unit

let show _of_json _to_json _ _ =
  Logs.app ~src (fun m -> m "[SHOW] %s" "id");
  Lwt.return_unit

let create _of_json _to_json _ _ =
  Logs.app ~src (fun m -> m "[CREATE] %s" "data");
  Lwt.return_unit

let update _of_json _to_json _ _ _ =
  Logs.app ~src (fun m -> m "[UPDATE] %s %s" "id" "data");
  Lwt.return_unit

let delete _of_json _to_json _ _ =
  Logs.app ~src (fun m -> m "[DELETE] %s" "id");
  Lwt.return_unit
