open Todo_model

val all : unit -> (Todo.t list, Error.t) result Lwt.t

val insert : string -> (unit, Error.t) result Lwt.t

val delete : int -> (unit, Error.t) result Lwt.t

val clear : unit -> (unit, Error.t) result Lwt.t
