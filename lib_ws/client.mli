open Websocket
open Websocket_lwt_unix

(** Represents a websocket client. *)
type t

(** Creates a new websocket client. *)
val make : int * Connected_client.t -> t

(** Gets a client identifier. *)
val id : t -> int

(** Returns [true] if the given client is currently connected. *)
val is_connected : t -> bool

(** Waits for a next [Frame.t] and returns it. *)
val receive : t -> Frame.t Lwt.t

(** Sends a message. *)
val send : t -> string -> unit Lwt.t

(** Sends multiple messages. *)
val send_multiple : t -> string list -> unit Lwt.t

(** Sends a PONG response. *)
val send_pong : t -> unit Lwt.t

(** Sends a CLOSE response with code 1000. *)
val send_close_normal : t -> unit Lwt.t

(** Sends a CLOSE response with the given [reason]. *)
val send_close_reason : reason:string -> t -> unit Lwt.t

(** Sends a CLOSE response. *)
val send_close : reason:string -> t -> unit Lwt.t

(** Marks client as disconnected from server. *)
val set_disconnected : t -> unit

(** Returns a string representation of the given client. *)
val to_string : t -> string
