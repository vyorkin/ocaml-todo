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

let to_string status =
  string_of_int @@ to_enum status
