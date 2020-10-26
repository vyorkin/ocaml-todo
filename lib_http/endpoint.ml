open Lwt.Syntax
open Todo_base

module Request = Opium.Std.Request

type handler = Request.t -> Opium.Std.Response.t Lwt.t

type 'a decoder = Yojson.Safe.t -> 'a
type 'b encoder = 'b -> Yojson.Safe.t

type 'a input = Request.t -> 'a Lwt.t
type 'b output = 'b -> Opium.Std.Response.t Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

module Param = struct
  open Opium.Std

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
end

let handle (input, output) f (req: Request.t) =
  try
    let* data = input req in
    match%lwt f data with
    | Ok result -> output result
    | Error err -> Response.error err
  with err ->
    Log.unhandled_error err;
    Response.server_error ()

let show encode =
  handle (Param.id, Response.json_opt encode)

let index encode =
  handle (Param.unit, Response.json_list encode)

let create (decode, encode) =
  handle (Param.json decode, Response.json encode)

let update (decode, encode) to_record =
  let input = Param.id_json decode to_record in
  let output = Response.json encode in
  handle (input, output)

let delete =
  handle (Param.id, Response.no_content)
