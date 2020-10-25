open Core_kernel
open Lwt.Syntax
open Websocket_lwt_unix

type t =
  { port: int;
    mode: Conduit_lwt_unix.server;
    next_id: int ref;
    next_id_lock: Lwt_mutex.t;
    clients: (int, Client.t) Hashtbl.t;
  }

type handlers =
  { on_connect: (Client.t -> unit Lwt.t) option;
    on_close: (Client.t -> string -> unit Lwt.t) option;
    on_error: (Client.t -> exn -> unit Lwt.t) option;
    on_message: (Client.t -> string -> unit Lwt.t);
  }

type tls =
  { crt: string;
    key: string;
  }

let src =
  Logs.Src.create "lib_ws.server"

let select_mode ?tls ~port =
  match tls with
  | None ->
     Logs.app ~src (fun m -> m "TCP mode selected");
     `TCP (`Port port)
  | Some tls ->
     Logs.app ~src (fun m -> m "TLS mode selected");
     `TLS (`Crt_file_path tls.crt,
           `Key_file_path tls.key,
           `No_password,
           `Port port)

let make ?tls ~port=
  let mode = select_mode ?tls ~port in
  let next_id = ref 1 in
  let next_id_lock = Lwt_mutex.create () in
  let clients = Hashtbl.create (module Int) ~size:32 in
  { port;
    mode;
    next_id;
    next_id_lock;
    clients;
  }

let check_request _ = true

let next_client_id srv =
  let+ () = Lwt_mutex.lock srv.next_id_lock in
  let client_id = !(srv.next_id) in
  srv.next_id := client_id + 1;
  Lwt_mutex.unlock srv.next_id_lock;
  client_id

let rec loop ~handlers srv client =
  let open Websocket in
  let id = Client.id client in
  let handle_msg () =
    let open Frame in
    let* frame = Client.receive client in
    match frame.opcode with
    | Opcode.Ping ->
       Client.send_pong client
    | Opcode.Text
    | Opcode.Binary ->
       let msg = frame.content in
       Logs.app ~src (fun m -> m "[RECV] %d: %s" id msg);
       let* () = handlers.on_message client msg in
       loop ~handlers srv client
    | Opcode.Close ->
       if Client.is_connected client
       then Hashtbl.remove srv.clients (Client.id client);
       Client.send_close ~reason:frame.content client
    | _ ->
       Lwt.return_unit
  in
  let handle_exn exn =
    let err = Exn.to_string exn in
    Logs.err ~src (fun m -> m "[RECV] %d: %s" id err);
    Hashtbl.remove srv.clients id;
    match handlers.on_error with
    | Some f -> f client exn
    | None -> Lwt.return_unit
  in
  Lwt.catch handle_msg handle_exn

let connect ~handlers srv conn =
  let* id = next_client_id srv in
  let client = Client.make (id, conn) in
  Hashtbl.add_exn srv.clients ~key:id ~data:client;
  let* () =
    match handlers.on_connect with
    | Some f -> f client
    | None -> Lwt.return_unit
  in
  loop ~handlers srv client

let start srv ?on_connect ?on_close ?on_error ~on_message =
  let handlers = { on_connect; on_close; on_error; on_message } in
  establish_server ~check_request ~mode:srv.mode (connect ~handlers srv)

let clients srv =
  Hashtbl.fold
    ~f:(fun ~key:_ ~data acc -> data :: acc)
    ~init:[]
    srv.clients

let close srv client =
  let id = Client.id client in
  Logs.app ~src (fun m -> m "[CLOSING] %d" id);
  match Hashtbl.find srv.clients id with
  | None ->
     Lwt.return_unit
  | Some client ->
     Hashtbl.remove srv.clients id;
     let* () = Client.send_close_normal client in
     Client.set_disconnected client;
     Lwt.return_unit

let close_all srv =
  Lwt_list.iter_p (close srv) (clients srv)

let connections srv =
  Hashtbl.length srv.clients

let broadcast_to clients msg =
  let num_clients = List.length clients in
  Logs.app ~src (fun m -> m "[BROADCASTING] %s to %d client(s)" msg num_clients);
  Lwt_list.iter_p (fun client -> Client.send client msg) clients

let broadcast srv =
  broadcast_to (clients srv)

let broadcast_to_others srv client msg =
  let id = Client.id client in
  let clients =
    List.filter
      ~f:(fun other -> Client.id other <> id)
      (clients srv)
  in
  broadcast_to clients msg
