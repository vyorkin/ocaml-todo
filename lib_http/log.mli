(** Returns a default [Logs.reporter]. *)
val default_reporter : unit -> Logs.reporter

(** Logs unhandled error. *)
val unhandled_error : exn -> unit
