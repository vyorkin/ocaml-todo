type status =
  | Pending
  | InProgress
  | Done
  [@@deriving show]

type t =
  { id: int [@default 0];
    content: string;
  } [@@deriving show, yojson { exn = true }]

val make: id:int -> content:string -> t
