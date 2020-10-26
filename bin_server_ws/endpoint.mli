open Todo_ws

type handler = string list -> Client.t -> unit Lwt.t

type 'a decoder = string -> 'a
type 'b encoder = 'b -> string

type 'a input = string list -> 'a
type 'b output = 'b -> Client.t -> unit Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

val handle : ('a, 'b) io -> ('a, 'b, 'c) query -> handler

val show : 'b encoder -> (int, 'b option, 'c) query -> handler

val index : 'b encoder -> (unit, 'b list, 'c) query -> handler

val create : ('a, 'b) codec -> ('a, 'b, 'c) query -> handler

val update : ('a, 'b) codec -> (int * 'a -> 'c) -> ('c, 'b, 'd) query -> handler

val delete : (int, unit, string) query -> handler
