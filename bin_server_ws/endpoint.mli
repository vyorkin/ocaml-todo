open Todo_ws

(** Represents a websocket server endpoint. *)
type t = Client.t -> string list -> unit Lwt.t

(** General handler of websocket request. *)
val handle :
  of_json:(string -> 'a Lwt.t) ->
  to_json:('b -> string) ->
  ('a -> ('b, 'c) result Lwt.t) ->
  Client.t ->
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
  ('a -> ('b, 'c) Lwt_result.t) ->
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
