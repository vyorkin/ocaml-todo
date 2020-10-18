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

module Q = struct
  let [@warning "-9"] create  =
    let open Todo in
    [%rapper execute
        {sql|
        INSERT INTO todo.todos(content)
        VALUES (%string{content})
        |sql}
        record_in
    ]

  let find =
    let open Todo in
    [%rapper get_one
        {sql|
        SELECT
          @int{id},
          @string{content}
        FROM todo.todos
        WHERE id = %int{id}
        |sql}
        record_out
    ]

  let all =
    let open Todo in
    [%rapper get_many
        {sql|
        SELECT
          @int{id},
          @string{content}
        FROM todo.todos
        |sql}
        record_out
    ]

  let destroy =
    [%rapper execute
        {sql|
        DELETE FROM todo.todos WHERE id = %int{id}
        |sql}
    ]
end

let create todo =
  Query.run (fun c -> Q.create todo c)

let find id =
  Query.run (fun c -> Q.find ~id c)

let all () =
  Query.run (fun c -> Q.all () c)

let destroy id =
  Query.run (fun c -> Q.destroy ~id c)
