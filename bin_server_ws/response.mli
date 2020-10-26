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

(** Respond with a given messages. *)
val respond : message list -> Client.t -> unit Lwt.t

val json :
  ?status:Status.t ->
  Client.t ->
  ('a -> Yojson.Safe.t) ->
  'a list ->
  unit Lwt.t

val no_content : Client.t -> unit Lwt.t

val not_found : Client.t -> unit Lwt.t

val server_error : Client.t -> unit Lwt.t
