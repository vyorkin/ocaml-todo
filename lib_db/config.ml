let db_uri () =
  let user = Sys.getenv_opt "DB_USER" |> Option.value ~default:"postgres" in
  let host = Sys.getenv_opt "DB_HOST" |> Option.value ~default:"localhost" in
  let port = Sys.getenv_opt "DB_PORT" |> Option.map int_of_string |> Option.value ~default:5432 in
  let db = Sys.getenv_opt "DB_DATABASE" |> Option.value ~default:"todo" in
  let uri = Printf.sprintf "postgresql://%s@%s:%i/%s" user host port db in
  Uri.of_string uri
