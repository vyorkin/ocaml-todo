module Body = Opium.Std.Body
module Response = Opium.Std.Response

type t =
  [ `Json of Yojson.Safe.t
  | `String of string
  | `Empty
  ]

let to_opium = function
  | `String s ->
     Body.of_string s
  | `Empty ->
     Body.empty
  | `Json json ->
     json
     |> Yojson.Safe.to_string
     |> Body.of_string

let to_response ?headers ?status body =
  Response.make ?headers ?status ~body:(to_opium body) () |> Lwt.return
