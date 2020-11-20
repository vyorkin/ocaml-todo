open Prometheus

module H = DefaultHistogram

let namespace = "todo"

module Ws = struct
  let subsystem = "websocket"
end

module Http = struct
  let label_names =
    ]

  module Request = struct
    let subsystem = "http_request"

    let duration_labels =
      H.v_labels
        ~label_names
        ~help:"Duration of HTTP request (sec)"
        ~namespace
        ~subsystem
        "duration_seconds"

    let size_labels =
      H.v_labels
        ~label_names
        ~help:"Size of HTTP request (bytes)"
        ~namespace
        ~subsystem
        "size_bytes"

    let duration ~meth ~path =
      H.labels duration_labels [ meth; path ]

    let size ~meth ~path =
      H.labels size_labels [ meth; path ]
  end

  module Response = struct
    let subsystem = "http_response"

    let size =
      Counter.v_label
        ~help:"Size of HTTP response (bytes)"
        ~label_name:"response"
        ~namespace
        ~subsystem
        "size_bytes"
  end
end
