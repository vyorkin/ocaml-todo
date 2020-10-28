open Prometheus

let namespace = "todo"

module Http = struct
  let subsystem = ""

  let req_duration_sec =
    Counter.v_label
      ~help:"Duration of HTTP requests (sec)"
      ~label_name:"request"
      ~namespace
      ~subsystem
      "request.duration.seconds"

  let req_size_bytes =
    Counter.v_label
      ~help:"Size of HTTP requests (bytes)"
      ~label_name:"request"
      ~namespace
      ~subsystem
      "request.size.bytes"

  let res_size_bytes =
    Counter.v_label
      ~help:"Size of HTTP response (bytes)"
      ~label_name:"response"
      ~namespace
      ~subsystem
      "response.size.bytes"
end
