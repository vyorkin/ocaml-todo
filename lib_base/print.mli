open Core_kernel

(** Creates a reference printer. *)
val to_ref : ('a -> 'b -> unit) -> 'a -> 'b ref -> unit

(** Pretty prints [Time.t] timestamp. *)
val timestamp : Format.formatter -> Time.t -> unit
