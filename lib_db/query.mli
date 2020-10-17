type ('r, 'e) t =
  Caqti_lwt.connection ->
  ('r, [< Caqti_error.t] as 'e) result Lwt.t

type nonrec ('r, 'e) result =
  ('r, [> Caqti_error.call_or_retrieve] as 'e) result Lwt.t

(* val run :
 *   ('r, [< Caqti_error.t > `Connect_failed `Connect_rejected `Post_connect ]) t ->
 *   Request.t ->
 *   ('r, string) Lwt_result.t *)
