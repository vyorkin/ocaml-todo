open Todo_ws

type t = Server.t * Client.t -> unit Lwt.t

module Todo = struct
  module Model = Todo_model.Todo
  module Db = Todo_db.Todo

  let list (_s, _c) =
    Lwt.return_unit

  let show ~id:_ (_s, _c) =
    Lwt.return_unit

  let create ~data:_ (_s, _c) =
    Lwt.return_unit

  let update ~id:_ ~data:_ (_s, _c) =
    Lwt.return_unit

  let delete ~id:_ (_s, _c) =
    Lwt.return_unit
end
