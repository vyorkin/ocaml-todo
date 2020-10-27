open Core_kernel
open Todo_ws

module Status = struct
  type t =
    | Ok [@value 200]
    | Created [@value 201]
    | No_content [@value 204]
    | Bad_request [@value 400]
    | Unauthorized [@value 401]
    | Forbidden [@value 403]
    | Not_found [@value 404]
    | Server_error [@value 500]
    | Not_implemented [@value 501]
    [@@deriving show, enum]

  let serialize status =
    string_of_int @@ to_enum status
end

type message = Status.t * string option

let serialize_content content =
  content
  |> Option.map ~f:(fun s -> "|" ^ s)
  |> Option.value ~default:""

let serialize (status, content) =
  let code = Status.serialize status in
  let body = serialize_content content in
  code ^ body

let message encode status text =
  (status, Some (encode text))

let respond data client =
  data
  |> serialize
  |> Client.send client

let respond_multi list client =
  list
  |> List.map ~f:serialize
  |> Client.send_multiple client

let no_content () =
  respond (Status.No_content, None)

let not_found =
  respond (Status.Not_found, None)

let json ?(status = Status.Ok) encode data client =
  let msg = message encode status data in
  respond msg client

let json_opt ?(status = Status.Ok) encode data client =
  match data with
  | None -> not_found client
  | Some data -> json ~status encode data client

let json_list ?(status = Status.Ok) encode list client =
  (** TODO: Serialize to a JSON array *)
  let messages = List.map ~f:(message encode status) list in
  respond_multi messages client

let server_error =
  let desc = "Unexpected internal server error" in
  respond (Status.Server_error, Some desc)
