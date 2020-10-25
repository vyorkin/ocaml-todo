type t

type tls =
  { crt: string;
    key: string;
  }

val make : ?tls:tls -> port:int -> t

val start :
  ?on_connect:(Client.t -> unit Lwt.t) ->
  ?on_close:(reason:string -> Client.t -> unit Lwt.t) ->
  ?on_error:(exn:exn -> Client.t -> unit Lwt.t) ->
  on_message:(message:string -> Client.t -> unit Lwt.t) ->
  t ->
  unit Lwt.t

val clients : t -> Client.t list

val find : t -> int -> Client.t option

val close : t -> Client.t -> unit Lwt.t

val close_all : t -> unit Lwt.t

val connections : t -> int

val broadcast_to : Client.t list -> string -> unit Lwt.t

val broadcast : t -> string -> unit Lwt.t

val broadcast_to_others : t -> Client.t -> string -> unit Lwt.t
