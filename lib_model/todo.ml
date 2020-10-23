type status =
  | Pending
  | InProgress
  | Done
  [@@deriving show]

type t =
  { id: int [@default 0];
    content: string;
  } [@@deriving show, yojson { exn = true }]

let make ~id ~content = { id; content }
