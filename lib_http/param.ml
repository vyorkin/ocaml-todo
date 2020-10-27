open Lwt.Syntax
open Opium.Std

module Request = Opium.Std.Request

let unit _ = Lwt.return ()

let id (req: Request.t) =
  "id" |> Router.param req |> int_of_string |> Lwt.return

let json decode (req: Request.t) =
  let+ json = Request.to_json_exn req in
  decode json

let id_json decode to_record (req: Request.t) =
  let* id = id req
  and* data = json decode req in
  Lwt.return @@ to_record (id, data)
