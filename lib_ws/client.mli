open Websocket
open Websocket_lwt_unix

type t

val make : int * Connected_client.t -> t

val id : t -> int

val is_connected : t -> bool

val receive : t -> Frame.t Lwt.t

val send : t -> string -> unit Lwt.t

val send_multiple : t -> string list -> unit Lwt.t

val send_pong : t -> unit Lwt.t

val send_close_normal : t -> unit Lwt.t

val send_close_reason : reason:string -> t -> unit Lwt.t

val send_close : reason:string -> t -> unit Lwt.t

val set_connected : t -> unit

val set_disconnected : t -> unit

val to_string : t -> string
