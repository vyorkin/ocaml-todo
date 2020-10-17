open Opium.Std

val make : ?pool_size:int -> url:string -> Rock.Middleware.t

(** Gets current connection pool from [Request.t]. *)
val pool : Request.t -> 'e Pool.t
