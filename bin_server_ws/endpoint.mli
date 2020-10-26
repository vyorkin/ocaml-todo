open Todo_ws

(** Represents a websocket server endpoint. *)
type t = Client.t -> string list -> unit Lwt.t

(** General handler of websocket request. *)
val handle :
  of_string:(string -> 'a Lwt.t) ->
  to_string:('b -> string) ->
  ('a -> ('b, 'c) result Lwt.t) ->
  Client.t ->
  t

val show :
  ('a -> string) ->
  (int -> ('a option, 'c) Lwt_result.t) ->
  t

val index :
  ('a -> string) ->
  (unit -> ('a list, 'c) Lwt_result.t) ->
  t

val create :
  (string -> 'a) ->
  ('b -> string) ->
  ('a -> ('b, 'c) Lwt_result.t) ->
  t

val update :
  (string -> 'a) ->
  ('b -> string) ->
  (int * 'a -> 'c) ->
  ('a -> ('b, 'c) Lwt_result.t) ->
  t

val delete : (int -> (unit, string) Lwt_result.t) -> t
