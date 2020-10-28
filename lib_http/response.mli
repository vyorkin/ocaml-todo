open Opium_kernel

(** Creates a "204 No Content" HTTP response. *)
val no_content : unit -> Response.t Lwt.t

(** Serializes a body using a give serializing function and
    responds with a given HTTP status code which defaults to "200 OK". *)
val json : ?status:Status.t -> ('a -> Yojson.Safe.t) -> 'a -> Response.t Lwt.t

(** Almost the same as [json] but
    with an optional response body. *)
val json_opt : ?status:Status.t -> ('a -> Yojson.Safe.t) -> 'a option -> Response.t Lwt.t

(** Almost the same as [json] but take a list instead of a single body. *)
val json_list : ?status:Status.t -> ('a -> Yojson.Safe.t) -> 'a list -> Response.t Lwt.t

(** Responds with a full error stack trace and description in
    development env and a short summary error description in production env. *)
val error : 'a -> Response.t Lwt.t

(** Almost the same as [error] but used in case of internal server errors and
    never provides any extra information when running in production env. *)
val server_error : unit -> Response.t Lwt.t
