open Lwt.Syntax
(* open Websocket *)
open Sexplib
open Cohttp
open Todo_base

module Server = Cohttp_lwt_unix.Server

type tls =
  { crt: string;
    key: string;
  }

type params =
  { port: int;
    tls: tls option;
    verbose: bool;
  }

let src = Logs.Src.create "todo_server_ws.server"

let init params =
  let reporter = Log.make_reporter ~verbose:params.verbose in
  Logs.set_reporter reporter

let select_mode params =
  match params.tls with
  | None ->
     Logs.app ~src (fun m -> m "TCP mode selected");
     `TCP (`Port params.port)
  | Some tls ->
     Logs.app ~src (fun m -> m "TLS mode selected");
     `TLS (`Crt_file_path tls.crt,
           `Key_file_path tls.key,
           `No_password,
           `Port params.port)

let on_request (_, conn) req body =
  Logs.app ~src (fun m -> m "[CONN] %a" Sexp.pp (Connection.sexp_of_t conn));
  let uri = Request.uri req in
  match Uri.path uri with
  | _ ->
     Logs.app ~src (fun m -> m "[PATH] ?");
     let* _ = Cohttp_lwt.Body.drain_body body in
     let body = Sexp.to_string_hum (Request.sexp_of_t req) in
     let* res = Server.respond_string ~status:`Not_found ~body () in
     Lwt.return @@ `Response res

let on_close (_, conn) =
  Logs.app ~src (fun m ->
      m "[SERV] connection %a closed" Sexp.pp (Connection.sexp_of_t conn))

let serve params =
  let mode = select_mode params in
  let srv =
    Server.make_response_action
      ~callback:on_request
      ~conn_closed:on_close
      ()
  in
  Server.create ~mode srv

let start params =
  init params;
  Lwt_main.run @@ serve params
