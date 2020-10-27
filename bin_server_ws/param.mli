val unit : 'a -> unit

val id : string list -> int

val json : ('a -> 'b) -> 'a list -> 'b

val id_json : (string -> 'a) -> (int * 'a -> 'b) -> string list -> 'b
