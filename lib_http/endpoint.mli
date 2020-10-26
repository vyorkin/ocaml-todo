open Opium.Std

module Response := Opium.Std.Response

type t = Request.t -> Response.t Lwt.t

val handle :
  input:(Request.t -> 'a Lwt.t) ->
  output:('b -> Response.t Lwt.t) ->
  ('a -> ('b, 'c) result Lwt.t) ->
  t

val create :
  (Yojson.Safe.t -> 'a) ->
  ('b -> Yojson.Safe.t) ->
  ('a -> ('b, 'c) Lwt_result.t) ->
  t

val update :
  (Yojson.Safe.t -> 'a) ->
  ('b -> Yojson.Safe.t) ->
  (int * 'a -> 'c) ->
  ('c -> ('b, 'd) Lwt_result.t) ->
  t

val delete : (int -> (unit, string) Lwt_result.t) -> t

val show :
  ('a -> Yojson.Safe.t) ->
  (int -> ('a option, 'c) Lwt_result.t) ->
  t

val index :
  ('a -> Yojson.Safe.t) ->
  (unit -> ('a list, 'c) Lwt_result.t) ->
  t
