open Todo_ws

module Status: sig
  (** Websocket server response status codes.
      Here we use status codes similar to those in HTTP. *)
  type t =
    | Ok
    | Created
    | No_content
    | Bad_request
    | Unauthorized
    | Forbidden
    | Not_found
    | Server_error
    | Not_implemented
    [@@deriving show, enum]
end

(** Response message. *)
type message = Status.t * string option

(** Respond with a given message. *)
val respond : message -> Client.t -> unit Lwt.t

(** Respond with multiple messages. *)
val respond_multi : message list -> Client.t -> unit Lwt.t

val no_content : unit -> Client.t -> unit Lwt.t

val not_found : Client.t -> unit Lwt.t

val json : ?status:Status.t -> ('a -> string) -> 'a -> Client.t -> unit Lwt.t

val json_opt : ?status:Status.t -> ('a -> string) -> 'a option -> Client.t -> unit Lwt.t

val json_list : ?status:Status.t -> ('a -> string) -> 'a list -> Client.t -> unit Lwt.t

val server_error : Client.t -> unit Lwt.t
