module Todo = struct
  type t =
    { content: string
    } [@@deriving show, of_yojson]
end
