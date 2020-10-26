open Todo_ws

(** Represents a request handler. *)
type t = Server.t * Client.t -> unit Lwt.t

module Todo: sig
  val list : t

  val show : id:string -> t

  val create : data:string -> t

  val update : id:string -> data:string -> t

  val delete : id:string -> t
end
