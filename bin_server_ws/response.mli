open Todo_ws

type 'a encoder = 'a -> Yojson.Safe.t

type handler = Client.t -> unit Lwt.t

(** Response JSON message. *)
type json = Status.t * Yojson.Safe.t option

(** Respond with a given JSON message. *)
val respond_json : json -> handler

(** Respond with multiple JSON messages. *)
val respond_json_multi : json list -> handler

val no_content : unit -> handler

val not_found : handler

val json : ?status:Status.t -> 'a encoder -> 'a -> handler

val json_opt : ?status:Status.t -> 'a encoder -> 'a option -> handler

val json_list : ?status:Status.t -> 'a encoder -> 'a list -> handler

val server_error : handler
