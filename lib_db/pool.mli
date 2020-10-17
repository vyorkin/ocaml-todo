open Caqti_lwt

(** Connection pool. *)
type 'e t =
  (connection, [> Caqti_error.connect] as 'e) Caqti_lwt.Pool.t

(** Creates a new connection pool. *)
val make : max_size:int -> string -> 'e t
