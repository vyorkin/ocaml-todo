let get_host () =
  "DB_HOST"
  |> Sys.getenv_opt
  |> Option.value ~default:"localhost"

let get_port () =
  "DB_PORT"
  |> Sys.getenv_opt
  |> Option.map int_of_string
  |> Option.value ~default:5432

let get_db () =
  "DB_DATABASE"
  |> Sys.getenv_opt
  |> Option.value ~default:"todo"

let make () =
  let host = get_host () in
  let port = get_port () in
  let db = get_db () in
  Printf.sprintf "postgresql://%s:%i/%s" host port db
