module Todo: sig
  open Endpoint

  val index : t

  val show : t

  val create : t

  val update : t

  val delete : t
end
