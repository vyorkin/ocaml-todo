type status =
  | Pending
  | InProgress
  | Done
  [@@deriving show]

type t =
  { id: int;
    content: string;
  } [@@deriving show, yojson]

val make: id:int -> content:string -> t
