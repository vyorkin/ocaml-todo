open Core

let make_args srv =
  let open Command.Let_syntax in
  [%map_open
   let port = flag "-port" (optional_with_default 8089 int) ~doc:"Websocket server port."
   and cert =
     both
       (flag "-cert" (optional string) ~doc:"Certificate file.")
       (flag "-cert-key" (optional string) ~doc:"Certificate key file.")
   and verbose = flag "-verbose" (optional_with_default false bool) ~doc:"Verbose output."
   in
   fun () ->
     let open Server in
     let tls =
       match cert with
       | Some crt, Some key -> Some { crt; key }
       | _, _ -> None
     in
     srv { port; tls; verbose }
  ]

let make_command srv =
  Command.basic
    ~summary:"Run a todo websocket server"
    ~readme:(fun () -> "This is an example todo websocket server")
    (make_args srv)

let () =
  Dotenv.export ();
  Server.start
  |> make_command
  |> Command.run
