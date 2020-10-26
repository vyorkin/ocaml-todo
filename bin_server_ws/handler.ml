module Todo = struct
  module Model = Todo_model.Todo
  module Db = Todo_db.Todo

  let src =
    Logs.Src.create "todo_server_ws.handler.todo"

  let list (_s, _c) =
    Logs.app ~src (fun m -> m "[LIST]");
    Lwt.return_unit

  let show ~id (_s, _c) =
    Logs.app ~src (fun m -> m "[SHOW] %s" id);
    Lwt.return_unit

  let create ~data (_s, _c) =
    Logs.app ~src (fun m -> m "[CREATE] %s" data);
    Lwt.return_unit

  let update ~id ~data (_s, _c) =
    Logs.app ~src (fun m -> m "[UPDATE] %s %s" id data);
    Lwt.return_unit

  let delete ~id (_s, _c) =
    Logs.app ~src (fun m -> m "[DELTE] %s" id);
    Lwt.return_unit
end

let src =
  Logs.Src.create "todo_server_ws.handler"

let unknown (_s, _c) =
  Logs.app ~src (fun m -> m "[UNKNOWN]");
  Lwt.return_unit
