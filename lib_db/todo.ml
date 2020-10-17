open Todo_model

module Status : Rapper.CUSTOM = struct
  type t =
    | Pending
    | InProgress
    | Done

  let t =
    let encode = function
      | Pending -> Ok "pending"
      | InProgress -> Ok "in-progress"
      | Done -> Ok "done"
    in
    let decode = function
      | "pending" -> Ok Pending
      | "in-progress" -> Ok InProgress
      | "done" -> Ok Done
      | _ -> Error "Invalid status"
  in
  Caqti_type.(custom ~encode ~decode string)
end

module Query = struct
  open Caqti_type
  open Caqti_request

  let all =
    collect unit (tup2 int string)
      "SELECT id, content FROM todo.todos"

  let insert =
    exec string
      "INSERT INTO todo.todos (content) VALUES (?)"

  let delete =
    exec int
      "DELETE FROM todo.todos WHERE id = ?"

  let clear =
    exec unit
      "TRUNCATE TABLE todo.todos"
end

let pool =
  let uri = Config.db_uri () in
  Pool.make ~uri ~max_size:5

let all () =
  let all' (module C : Caqti_lwt.CONNECTION) =
    C.fold Query.all (fun (id, content) acc ->
        { Todo.id; content } :: acc) () []
  in
  Caqti_lwt.Pool.use all' pool |> Error.unwrap

(* let all' =
 *   [%rapper get_many
 *    {sql|
 *     SELECT @int{id}, %string{content}
 *     FROM todo.todos
 *    |sql} record_out] *)

let insert content =
  let insert' content (module C : Caqti_lwt.CONNECTION) =
    C.exec Query.insert content
  in
  Caqti_lwt.Pool.use (insert' content) pool |> Error.unwrap

let delete id =
  let delete' id (module C : Caqti_lwt.CONNECTION) =
    C.exec Query.delete id
  in
  Caqti_lwt.Pool.use (delete' id) pool |> Error.unwrap

let clear () =
  let clear' (module C : Caqti_lwt.CONNECTION) =
    C.exec Query.clear ()
  in
  Caqti_lwt.Pool.use clear' pool |> Error.unwrap
