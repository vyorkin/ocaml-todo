open Core_kernel
open Lwt.Syntax

module Todo = struct
  module Model = Todo_model.Todo
  module Endpoint = Todo_http.Endpoint
  module Db = Todo_db.Todo

  let create =
    Endpoint.create
      Model.of_yojson_exn
      Model.to_yojson
      Db.create

  let update =
    Endpoint.update
      Model.of_yojson_exn
      Model.to_yojson
      (fun (id, r) -> { r with id })
      (fun r -> let+ r' = Db.update r in Result.map ~f:(Fn.const r) r')

  let delete =
    Endpoint.delete Db.destroy

  let show =
    Endpoint.show Model.to_yojson Db.find

  let index =
    Endpoint.index Model.to_yojson Db.all
end
