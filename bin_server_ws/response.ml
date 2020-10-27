open Core_kernel
open Todo_ws

type 'a encoder = 'a -> Yojson.Safe.t

type handler = Client.t -> unit Lwt.t

type json = Status.t * Yojson.Safe.t option

let serialize_json json =
  json
  |> Option.map ~f:(fun s -> "|" ^ Yojson.Safe.to_string s)
  |> Option.value ~default:""

let serialize (status, json) =
  let code = Status.to_string status in
  let body = serialize_json json in
  code ^ body

let respond_json messsage client =
  messsage
  |> serialize
  |> Client.send client

let respond_json_multi messages client =
  messages
  |> List.map ~f:serialize
  |> Client.send_multiple client

let no_content () =
  respond_json (Status.No_content, None)

let not_found =
  respond_json (Status.Not_found, None)

let json ?(status = Status.Ok) encode data =
  respond_json (status, Some (encode data))

let json_opt ?(status = Status.Ok) encode data client =
  match data with
  | None -> not_found client
  | Some data -> json ~status encode data client

let json_list ?(status = Status.Ok) encode list =
  let data = List.map ~f:encode list in
  respond_json (status, Some (`List data))

let server_error =
  let desc = "Unexpected internal server error" in
  respond_json (Status.Server_error, Some (`String desc))
