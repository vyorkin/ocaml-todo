open Core_kernel
open Websocket
open Websocket_lwt_unix

type status =
  | Connected
  | Disconnected
  [@@deriving eq]

type t =
  { id: int;
    conn: Connected_client.t;
    status: status ref;
  }

let src =
  Logs.Src.create "lib_ws.client"

let make (id, conn) =
  { id; conn; status = ref Connected }

let id { id; _ } = id

let is_connected { status; _ } =
  equal_status !status Connected

let make_frame content =
  Frame.(create ~content ~final:true ~opcode:Opcode.Text ())

let receive client =
  Connected_client.recv client.conn

let send client content =
  let frame = make_frame content in
  Logs.app ~src (fun m -> m "[SEND] %d: %s" client.id content);
  Connected_client.send client.conn frame

let send_multiple client content_list =
  let frames = List.map ~f:make_frame content_list in
  let contents = String.concat ~sep:", " content_list in
  Logs.app ~src (fun m -> m "[SEND_MULTIPLE] %d: %s" client.id contents);
  Connected_client.send_multiple client.conn frames

let send_pong client =
  Logs.app ~src (fun m -> m "[SEND PONG] %d" client.id);
  let frame = Frame.(create ~opcode:Opcode.Pong ()) in
  Connected_client.send client.conn frame

let send_close_normal client =
  Logs.app ~src (fun m -> m "[SEND CLOSE] %d 1000" client.id);
  let frame = Frame.close 1000 in
  Connected_client.send client.conn frame

let send_close_reason ~reason client =
  let content = String.slice reason 0 2 in
  Logs.app ~src (fun m -> m "[SEND CLOSE] %d %s" client.id content);
  let frame = Frame.(create ~opcode:Opcode.Close ~content ()) in
  Connected_client.send client.conn frame

let send_close ~reason client =
  if String.length reason >= 2
  then send_close_reason ~reason client
  else send_close_normal client

let set_connected client =
  Logs.app ~src (fun m -> m "[CONNECTED] %d" client.id);
  client.status := Connected

let set_disconnected client =
  Logs.app ~src (fun m -> m "[DISCONNECTED] %d" client.id);
  client.status := Disconnected
