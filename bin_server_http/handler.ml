module Todo = struct
  open Todo_model
  open Todo_http
  open Todo_db.Todo

  let show =
    Endpoint.show Todo.to_yojson find

  let index =
    Endpoint.index Todo.to_yojson all
end
