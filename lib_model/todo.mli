type status =
  | Pending
  | InProgress
  | Done
  [@@deriving show]

type t =
  { id: int option;
    content: string;
  } [@@deriving show, to_yojson]

val make: id:int option -> content:string -> t
