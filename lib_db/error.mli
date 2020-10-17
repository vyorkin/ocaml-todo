type t =
  | DbError of string
  [@@deriving show]

val or_db_error :
  ('a, [< Caqti_error.t]) result Lwt.t ->
  ('a, t) result Lwt.t
