type t

type tls =
  { crt: string;
    key: string;
  }

val make : ?tls:tls -> port:int -> t

val start :
  t ->
  ?on_connect:(Client.t -> unit Lwt.t) ->
  ?on_close:(Client.t -> string -> unit Lwt.t) ->
  ?on_error:(Client.t -> exn -> unit Lwt.t) ->
  on_message:(Client.t -> string -> unit Lwt.t) ->
  unit Lwt.t

val clients : t -> Client.t list

val close : t -> Client.t -> unit Lwt.t

val close_all : t -> unit Lwt.t

val connections : t -> int
