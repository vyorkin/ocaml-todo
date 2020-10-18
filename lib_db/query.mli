type ('r, 'e) callback =
  Caqti_lwt.connection -> ('r, [< Caqti_error.t] as 'e) result Lwt.t

type nonrec ('r, 'e) result =
  ('r, [> Caqti_error.call_or_retrieve] as 'e) result Lwt.t

type ('r, 'e) t =
  ('r, [< Caqti_error.t > `Connect_failed `Connect_rejected `Post_connect ] as 'e) callback

(** Runs a query callback, gives it a [Caqti_lwt.connection] from
    ['e Pool.t] and returns [Ok 'r] of ['r] obtained by executing a database query,
    otherwise returns [Error 'e] reporting an error causing query to fail. *)
val run : ?pool:'e Pool.t Lazy.t -> ('r, 'e) t -> ('r, string) Lwt_result.t
