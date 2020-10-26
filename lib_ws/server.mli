(** Represents a websocket server. *)
type t

(** TLS connection settings. *)
type tls =
  { crt: string;
    key: string;
  }

(** Initializes a new websocket server on the given [port]. *)
val make : ?tls:tls -> port:int -> t

(** Stars a websocket server. *)
val start :
  ?on_connect:(Client.t -> unit Lwt.t) ->
  ?on_close:(reason:string -> Client.t -> unit Lwt.t) ->
  ?on_error:(exn:exn -> Client.t -> unit Lwt.t) ->
  on_message:(message:string -> Client.t -> unit Lwt.t) ->
  t ->
  unit Lwt.t

(** Gets a list of currently connected clients. *)
val clients : t -> Client.t list

(** Finds a client with a given id. *)
val find : t -> int -> Client.t option

(** Closes a client connection. *)
val close : t -> Client.t -> unit Lwt.t

(** Closes all connections. *)
val close_all : t -> unit Lwt.t

(** Gets a number of active connections. *)
val connections : t -> int

(** Broadcasts a message to the given list of clients. *)
val broadcast_to : Client.t list -> string -> unit Lwt.t

(** Broadcasts a message to all connected clients. *)
val broadcast : t -> string -> unit Lwt.t

(** Broadcasts a message to all connected clients, except the given client. *)
val broadcast_to_others : t -> Client.t -> string -> unit Lwt.t
