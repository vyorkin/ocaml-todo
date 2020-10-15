type error =
  | DbError of string

let or_error m =
  match%lwt m with
  | Ok x ->
     Lwt.return (Ok x)
  | Error e ->
     Lwt.return (Error (DbError (Caqti_error.show e)))
