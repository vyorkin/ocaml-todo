val run :
  ((module Caqti_lwt.CONNECTION) -> ('r, ([> Caqti_error.transact] as 'e)) result Lwt.t) ->
  (module Caqti_lwt.CONNECTION) ->
  ('r, 'e) result Lwt.t
