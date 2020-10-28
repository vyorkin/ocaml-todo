val unit : 'a -> unit

val id : string list -> int

val json : (Yojson.Safe.t -> 'b) -> string list -> 'b

val id_json : (Yojson.Safe.t -> 'a) -> (int * 'a -> 'b) -> string list -> 'b
