open Model

type error =
  | DbError of string

module Todo: sig
  val all : unit -> (todo list, error) result Lwt.t
  val insert : string -> (unit, error) result Lwt.t
  val delete : int -> (unit, error) result Lwt.t
  val clear : unit -> (unit, error) result Lwt.t
end
