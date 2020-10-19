open Opium_kernel

module Response := Opium.Std.Response
module Body := Opium.Std.Body

(** Custom type representing a response body. *)
type t =
  [ `Json of Yojson.Safe.t
  | `String of string
  | `Empty
  ]

(** Converts our custom body type [t] to [Opium.Std.Body.t]. *)
val to_opium : t -> Body.t

(** Makes a [Response.t] out of [t] with optional
    [Opium_kernel.Headers.t] and [Opium_kernel.Status.t]. *)
val to_response : ?headers:Headers.t -> ?status:Status.t -> t -> Response.t Lwt.t
