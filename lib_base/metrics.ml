open Prometheus

let namespace = "todo"

module Http = struct
  module Request = struct
    let subsystem = "http.request"

    let duration =
      Counter.v_label
        ~help:"Duration of HTTP request (sec)"
        ~label_name:"request"
        ~namespace
        ~subsystem
        "duration.seconds"

    let size =
      Counter.v_label
        ~help:"Size of HTTP request (bytes)"
        ~label_name:"request"
        ~namespace
        ~subsystem
        "size.bytes"
  end

  module Response = struct
    let subsystem = "http.response"

    let size =
      Counter.v_label
        ~help:"Size of HTTP response (bytes)"
        ~label_name:"response"
        ~namespace
        ~subsystem
        "response.size.bytes"
  end
end
