open Opium.Std

type t = Request.t -> Response.t Lwt.t

type 'a decoder = Yojson.Safe.t -> 'a
type 'b encoder = 'b -> Yojson.Safe.t

type 'a input = Request.t -> 'a Lwt.t
type 'b output = 'b -> Opium.Std.Response.t Lwt.t

type ('a, 'b) io = 'a input * 'b output
type ('a, 'b) codec = 'a decoder * 'b encoder
type ('a, 'b, 'c) query = 'a -> ('b, 'c) result Lwt.t

val handle : ('a, 'b) io -> ('a, 'b, 'c) query -> t

val show : 'a encoder -> (int, 'a option, 'b) query -> t

val index : 'a encoder -> (unit, 'a list, 'c) query -> t

val create : ('a, 'b) codec -> ('a, 'b, 'c) query -> t

val update : ('a, 'b) codec -> (int * 'a -> 'c) -> ('c, 'b, 'd) query -> t

val delete : (int, unit, string) query -> t
