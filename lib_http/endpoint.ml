open Lwt.Syntax
open Todo_base

module Request = Opium.Std.Request

type t = Request.t -> Opium.Std.Response.t Lwt.t

module Param = struct
  open Opium.Std

  let unit _ = Lwt.return ()

  let id (req: Request.t) =
    "id" |> Router.param req |> int_of_string |> Lwt.return

  let json of_json (req: Request.t) =
    let+ json = Request.to_json_exn req in
    of_json json

  let id_json of_json to_record (req: Request.t) =
    let* id = id req in
    let* data = json of_json req in
    Lwt.return @@ to_record (id, data)
end

let handle ~input ~output f (req: Request.t) =
  try
    let* data = input req in
    match%lwt f data with
    | Ok result -> output result
    | Error err -> Response.error err
  with err ->
    Log.unhandled_error err;
    Response.server_error ()

let create of_json to_json =
  handle
    ~input:(Param.json of_json)
    ~output:(Response.json to_json)

let update of_json to_json to_record =
  handle
    ~input:(Param.id_json of_json to_record)
    ~output:(Response.json to_json)

let delete =
  handle
    ~input:Param.id
    ~output:Response.no_content

let show to_json =
  handle
    ~input:Param.id
    ~output:(Response.json_opt to_json)

let index to_json =
  handle
    ~input:Param.unit
    ~output:(Response.json_list to_json)
