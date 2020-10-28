open Prometheus

module Http: sig
  module Request: sig
    val duration : string -> Counter.t

    val size : string -> Counter.t
  end

  module Response: sig
    val size : string -> Counter.t
  end
end
