open Prometheus

module H = DefaultHistogram

module Ws = struct
  let namespace = "todo.ws"
end

module Http = struct
  let namespace = "todo.http"

  let label_names =
    [ "method";
      "path"
    ]

  module Request = struct
    let subsystem = "request"

    let duration_labels =
      H.v_labels
        ~label_names
        ~help:"Duration of HTTP request (sec)"
        ~namespace
        ~subsystem
        "duration.seconds"

    let size_labels =
      H.v_labels
        ~label_names
        ~help:"Size of HTTP request (bytes)"
        ~namespace
        ~subsystem
        "size.bytes"

    let duration ~meth ~path =
      H.labels duration_labels [ meth; path ]

    let size ~meth ~path =
      H.labels size_labels [ meth; path ]
  end

  module Response = struct
    let subsystem = "response"

    let size =
      Counter.v_label
        ~help:"Size of HTTP response (bytes)"
        ~label_name:"response"
        ~namespace
        ~subsystem
        "response.size.bytes"
  end
end
