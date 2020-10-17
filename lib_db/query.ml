type ('r, 'e) callback =
  Caqti_lwt.connection -> ('r, [< Caqti_error.t] as 'e) result Lwt.t

type nonrec ('r, 'e) result =
  ('r, [> Caqti_error.call_or_retrieve] as 'e) result Lwt.t

type ('r, 'e) t =
  ('r, [< Caqti_error.t > `Connect_failed `Connect_rejected `Post_connect ] as 'e) callback

let run ~pool query =
  pool
  |> Caqti_lwt.Pool.use query
  |> Lwt_result.map_err Caqti_error.show
