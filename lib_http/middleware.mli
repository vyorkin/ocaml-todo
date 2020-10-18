module Logging: sig
  open Opium.Std

  val middleware : Rock.Middleware.t
end

module Metrics: sig
end
