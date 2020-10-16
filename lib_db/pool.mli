open Caqti_lwt

val make :
  ?max_size:int ->
  string ->
  (connection, [> Caqti_error.connect ]) Caqti_lwt.Pool.t
