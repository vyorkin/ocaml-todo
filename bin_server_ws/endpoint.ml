open Core_kernel
open Todo_base
open Todo_ws

type t = string list -> Client.t -> unit Lwt.t

type 'a decoder = Yojson.Safe.t -> 'a
type 'b encoder = 'b -> Yojson.Safe.t

type 'a input = string list -> 'a
type 'b output = 'b -> Client.t -> unit Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

let handle (input, output) f data client =
  try
    let params = input data in
    match%lwt f params with
    | Ok result -> output result client
    | Error _ -> Response.server_error client
  with err ->
    Log.unhandled_error err;
    Response.server_error client

let show encode =
  handle (Param.id, Response.json_opt encode)

let index encode =
  handle (Param.unit, Response.json_list encode)

let create ((decode, encode) : ('a, 'b) codec) (query : ('a, 'b, 'c) query) (l : string list) (c : Client.t) : unit Lwt.t =
  let i = Param.json decode in
  let o = Response.json ~status:Status.Created encode in
  handle (i, o) query l c

let update (decode, encode) to_record =
  let i = Param.id_json decode to_record in
  let o = Response.json encode in
  handle (i, o)

let delete =
  handle (Param.id, Response.no_content)
