(** Make a [Logs.reporter]. *)
val make_reporter : verbose:bool -> Logs.reporter

(** Logs unhandled error. *)
val unhandled_error : exn -> unit
