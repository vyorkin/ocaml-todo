open Caqti_lwt

(** Connection pool. *)
type 'e t =
  (connection, [> Caqti_error.connect] as 'e) Caqti_lwt.Pool.t

(** Creates a new connection pool of size [max_size] given a connection [Uri.t].
    The URI should be something like ["postgresql://username:password@localhost:5432/postgres"]. *)
val make : uri:Uri.t -> max_size:int -> 'e t
