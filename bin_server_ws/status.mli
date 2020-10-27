(** Websocket server response status codes.
    Here we use status codes similar to those in HTTP. *)
type t =
  | Ok
  | Created
  | No_content
  | Bad_request
  | Unauthorized
  | Forbidden
  | Not_found
  | Server_error
  | Not_implemented
  [@@deriving show, enum]

val to_string : t -> string
