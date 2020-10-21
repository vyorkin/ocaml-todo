module Todo = struct
  module Model = Todo_model.Todo
  module Endpoint = Todo_http.Endpoint
  module Db = Todo_db.Todo

  let show =
    Endpoint.show Model.to_yojson Db.find

  let index =
    Endpoint.index Model.to_yojson Db.all
end
