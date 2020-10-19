open Opium.Std

module Response := Opium.Std.Response

type t = Request.t -> Response.t Lwt.t

val handle :
  input:(Request.t -> 'a Lwt.t) ->
  output:('b -> Response.t Lwt.t) ->
  ('a -> ('b, 'c) result Lwt.t) ->
  Request.t ->
  Response.t Lwt.t

val show :
  ('a -> Yojson.Safe.t) ->
  (int -> ('a option, string) Lwt_result.t) ->
  Request.t ->
  Response.t Lwt.t

val index :
  ('a -> Yojson.Safe.t) ->
  (unit -> ('a list, string) Lwt_result.t) ->
  Request.t ->
  Response.t Lwt.t
