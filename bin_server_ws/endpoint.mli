open Todo_ws

type t = string list -> Client.t -> unit Lwt.t

type 'a decoder = Yojson.Safe.t -> 'a
type 'b encoder = 'b -> Yojson.Safe.t

type 'a input = string list -> 'a
type 'b output = 'b -> Client.t -> unit Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

val handle : ('a, 'b) io -> ('a, 'b, 'c) query -> t

val show : 'b encoder -> (int, 'b option, 'c) query -> t

val index : 'b encoder -> (unit, 'b list, 'c) query -> t

val create : ('a, 'b) codec -> ('a, 'b, 'c) query -> t

val update : ('a, 'b) codec -> (int * 'a -> 'c) -> ('c, 'b, 'd) query -> t

val delete : (int, unit, string) query -> t
