type status =
  | Pending
  | InProgress
  | Done
  [@@deriving show]

type t =
  { id: int;
    content: string;
  } [@@deriving show, to_yojson]

val make: id:int -> content:string -> t
