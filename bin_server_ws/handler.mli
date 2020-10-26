module Todo: sig
  open Endpoint

  val index : handler

  val show : handler

  val create : handler

  val update : handler

  val delete : handler
end
