let db_uri () =
  let host = Sys.getenv "DB_HOST" in
  let port = int_of_string @@ Sys.getenv "DB_PORT" in
  let db = Sys.getenv "DB_DATABASE" in
  let uri = Printf.sprintf "postgresql://%s:%i/%s" host port db in
  Uri.of_string uri
