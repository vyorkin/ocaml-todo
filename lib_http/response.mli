open Opium_kernel

module Response := Opium.Std.Response

val no_content : unit -> Response.t Lwt.t

val json : ('a -> Yojson.Safe.t) -> 'a -> Response.t Lwt.t

val json_opt : ?status:Status.t -> ('a -> Yojson.Safe.t) -> 'a option -> Response.t Lwt.t

val json_list : ('a -> Yojson.Safe.t) -> 'a list -> Response.t Lwt.t

val error : 'a -> Response.t Lwt.t

val internal_server_error : unit -> Response.t Lwt.t
