open Core_kernel

let no_content () =
  `String "" |> Body.to_response ~status:`No_content

let json ?status to_json data =
  `Json (to_json data) |> Body.to_response ?status

let json_opt ?status to_json = function
  | None -> `String "" |> Body.to_response ~status:`Not_found
  | Some data -> json ?status to_json data

let json_list ?status to_json data =
  let list = List.map ~f:to_json data in
  `Json (`List list) |> Body.to_response ?status

let error _ =
  (* TODO: Respond with a full error stack trace and description
     in development env and a short summary in production env. *)
  no_content ()

let server_error () =
  `String "Internal server error"
  |> Body.to_response ~status:`Internal_server_error
