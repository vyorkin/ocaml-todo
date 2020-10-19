open Core_kernel

let no_content () =
  `String "" |> Body.to_response ~status:`No_content

let json to_json content =
  `Json (to_json content) |> Body.to_response

let json_opt ?(status = `Not_found) to_json = function
  | None -> `String "" |> Body.to_response ~status
  | Some content -> json to_json content

let json_list to_json content =
  let list = List.map content ~f:to_json in
  `Json (`List list) |> Body.to_response

let error _ = no_content ()

let internal_server_error () =
  `String "Internal server error"
  |> Body.to_response ~status:`Internal_server_error
