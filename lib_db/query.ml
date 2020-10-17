open Opium.Std

type ('r, 'e) t =
  Caqti_lwt.connection ->
  ('r, [< Caqti_error.t] as 'e) result Lwt.t

type nonrec ('r, 'e) result =
  ('r, [> Caqti_error.call_or_retrieve] as 'e) result Lwt.t

let run q (req: Request.t) =
  req.env
  |> Middleware.pool
  |> Caqti_lwt.Pool.use q
  |> Lwt_result.map_err Caqti_error.show
