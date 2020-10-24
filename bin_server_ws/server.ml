open Lwt.Syntax
open Websocket
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

let src =
  Logs.Src.create "todo_server_ws.server"

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

let log_frame frame =
  let open Frame in
  match frame.opcode with
  | Opcode.Close ->
     Logs.app ~src (fun m -> m "[RECV] CLOSE")
  | _ ->
     let msg = frame.content in
     Logs.app ~src (fun m -> m "[RECV] %s" msg)

let on_request ~req ~body =
  let open Websocket_cohttp_lwt in
  let* _ = Cohttp_lwt.Body.drain_body body in
  let* (res, out) = upgrade_connection req log_frame in
  let frame = Frame.create ~content:"Hello world" () in
  let* _ = Lwt.wrap1 out (Some frame) in
  Lwt.return res

let on_close (_, conn) =
  Logs.app ~src (fun m ->
      m "[SERV] connection %a closed" Sexp.pp (Connection.sexp_of_t conn))

let handle (_, conn) req body =
  Logs.app ~src (fun m -> m "[CONN] %a" Sexp.pp (Connection.sexp_of_t conn));
  let path = Uri.path (Request.uri req) in
  Logs.app ~src (fun m -> m "[PATH] %s" path);
  match path with
  | "/" ->
     on_request ~req ~body
  | _ ->
     let body = Sexp.to_string_hum @@ Request.sexp_of_t req in
     let* res = Server.respond_string ~status:`Not_found ~body () in
     Lwt.return @@ `Response res

let serve params =
  let mode = select_mode params in
  let srv =
    Server.make_response_action
      ~callback:handle
      ~conn_closed:on_close
      ()
  in
  Server.create ~mode srv

let start params =
  init params;
  Lwt_main.run @@ serve params
