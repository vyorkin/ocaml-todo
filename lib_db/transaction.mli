open Caqti_lwt

val run :
  ((module CONNECTION) -> ('r, ([> Caqti_error.transact] as 'e)) result Lwt.t) ->
  (module CONNECTION) ->
  ('r, 'e) result Lwt.t
