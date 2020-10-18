(** Represents status/result running of running HTTP server. *)
type 'a status = [> `Ok of unit Lwt.t | `Error | `Not_running] as 'a

(** Runs an HTTP server. *)
val run : name:string -> 'a status
