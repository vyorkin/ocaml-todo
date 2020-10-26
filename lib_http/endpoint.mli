open Opium.Std

module Response := Opium.Std.Response

type handler = Request.t -> Response.t Lwt.t

type 'a decoder = Yojson.Safe.t -> 'a
type 'b encoder = 'b -> Yojson.Safe.t

type 'a input = Request.t -> 'a Lwt.t
type 'b output = 'b -> Opium.Std.Response.t Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

val handle : ('a, 'b) io -> ('a, 'b, 'c) query -> handler

val show : 'a encoder -> (int, 'a option, 'b) query -> handler

val index : 'a encoder -> (unit, 'a list, 'c) query -> handler

val create : ('a, 'b) codec -> ('a, 'b, 'c) query -> handler

val update : ('a, 'b) codec -> (int * 'a -> 'c) -> ('c, 'b, 'd) query -> handler

val delete : (int, unit, string) query -> handler
