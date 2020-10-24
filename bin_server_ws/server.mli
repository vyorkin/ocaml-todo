type tls =
  { crt: string;
    key: string;
  }

type params =
  { port: int;
    tls: tls option;
    verbose: bool;
  }

(** Runs a websocker server. *)
val start : params -> unit
