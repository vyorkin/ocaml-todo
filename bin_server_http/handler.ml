open Opium.Std

module Db = Todo_db
module Model = Todo_model

module Todo = struct
  let show (req : Request.t) =
    let id = Router.param req "id" |> int_of_string in
    match%lwt Db.Todo.find id with
    | Ok x ->
       Lwt.return @@ Response.of_json (Model.Todo.to_yojson x)
    | Error err ->
       Lwt.return @@ Response.of_json  (`Assoc [ "error", `String err ])
end
