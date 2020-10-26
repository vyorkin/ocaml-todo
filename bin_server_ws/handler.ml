open Core_kernel
open Lwt.Syntax

module Todo = struct
  module Model = Todo_model.Todo
  module Db = Todo_db.Todo

  let decode str =
    str
    |> Yojson.Safe.from_string
    |> Model.of_yojson_exn

  let encode record =
    record
    |> Model.to_yojson
    |> Yojson.Safe.to_string

  let codec = (decode, encode)

  let show =
    Endpoint.show encode Db.find

  let index =
    Endpoint.index encode Db.all

  let create =
    Endpoint.create codec Db.create

  let update =
    Endpoint.update
      codec
      (fun (id, r) -> { r with id })
      (fun r -> let+ r' = Db.update r in Result.map ~f:(Fn.const r) r')

  let delete =
    Endpoint.delete Db.destroy
end
