type t = Opium.Std.Request.t -> Opium.Std.Response.t Lwt.t

module Param = struct
  open Opium.Std

  let unit _ = Lwt.return ()

  let id (req: Request.t) =
    "id" |> Router.param req |> int_of_string |> Lwt.return
end

let handle ~input ~output f (req : Opium.Std.Request.t) =
  try
    let%lwt payload = input req in
    match%lwt f payload with
    | Ok result -> output result
    | Error err -> Response.error err
  with err ->
    let msg = Printexc.to_string err and
        stack = Printexc.get_backtrace ()
    in
    Logs.err (fun m -> m "Uncaught exception: %s\n%s" msg stack);
    Response.internal_server_error ()

let show to_json =
  handle
    ~input:Param.id
    ~output:(Response.json_opt to_json)

let index to_json =
  handle
    ~input:Param.unit
    ~output:(Response.json_list to_json)
