open Todo_model

val all : unit -> (Todo.t list, error) result Lwt.t

val insert : string -> (unit, error) result Lwt.t

val delete : int -> (unit, error) result Lwt.t

val clear : unit -> (unit, error) result Lwt.t
