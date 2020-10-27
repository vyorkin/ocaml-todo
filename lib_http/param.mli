open Opium.Std

val unit : 'a -> unit Lwt.t

val id : Request.t -> int Lwt.t

val json : (Yojson.Safe.t -> 'a) -> Request.t -> 'a Lwt.t

val id_json : (Yojson.Safe.t -> 'a) -> (int * 'a -> 'b) -> Request.t -> 'b Lwt.t
