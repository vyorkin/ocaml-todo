type t =
  | DbError of string
  [@@deriving show]

val unwrap :
  ('a, [< Caqti_error.t]) result Lwt.t ->
  ('a, t) result Lwt.t
