open Todo_ws

type params =
  { verbose: bool;
    port: int;
    tls: Server.tls option;
  }

(** Runs an app with the given [params]. *)
val start : params -> unit
