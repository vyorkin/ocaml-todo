open Prometheus

module H = DefaultHistogram

module Http: sig
  module Request: sig
    val duration : meth:string -> path:string -> H.t

    val size : meth:string -> path:string -> H.t
  end

  module Response: sig
    val size : meth:string -> path:string -> H.t
  end
end
