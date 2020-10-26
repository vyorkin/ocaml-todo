open Core_kernel
open Todo_base
open Todo_ws

type handler = string list -> Client.t -> unit Lwt.t

type 'a decoder = string -> 'a
type 'b encoder = 'b -> string

type 'a input = string list -> 'a
type 'b output = 'b -> Client.t -> unit Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

module Param = struct
  let unit _ = ()

  let id = function
    | s :: _ -> int_of_string s
    | _ -> failwith "id parameter missing"

  let json decode data =
    data |> List.hd_exn |> decode

  let id_json decode to_record list =
    match list with
    | s1 :: s2 :: _ ->
       let id' = id [ s1 ] in
       let data = json decode [ s2 ] in
       to_record (id', data)
    | _ -> failwith "id or json parameters are missing"
end

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

let create (decode, encode) =
  handle (Param.json decode, Response.json encode)

let update (decode, encode) to_record =
  let i = Param.id_json decode to_record in
  let o = Response.json encode in
  handle (i, o)

let delete =
  handle (Param.id, Response.no_content)
