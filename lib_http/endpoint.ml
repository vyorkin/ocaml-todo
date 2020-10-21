module Request = Opium.Std.Request

type t = Request.t -> Opium.Std.Response.t Lwt.t

module Param = struct
  open Opium.Std

  let unit _ = Lwt.return ()

  let id (req: Request.t) =
    "id" |> Router.param req |> int_of_string |> Lwt.return

  let json f (req: Request.t) =
    let open Lwt.Syntax in
    let+ json = Request.to_json_exn req in
    f json
end

let log_error err =
  let msg = Printexc.to_string err in
  let stack = Printexc.get_backtrace () in
  Logs.err (fun m -> m "Uncaught exception: %s\n%s" msg stack)

let handle ~input ~output f (req : Request.t) =
  let open Lwt.Syntax in
  try
    let* payload = input req in
    match%lwt f payload with
    | Ok result -> output result
    | Error err -> Response.error err
  with err ->
    log_error err;
    Response.internal_server_error ()

let create of_json to_json =
  handle
    ~input:(Param.json of_json)
    ~output:(Response.json to_json)

let show to_json =
  handle
    ~input:Param.id
    ~output:(Response.json_opt to_json)

let index to_json =
  handle
    ~input:Param.unit
    ~output:(Response.json_list to_json)
