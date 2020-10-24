open Core_kernel
open Todo_base

let init app =
  let reporter = Log.make_reporter ~verbose:false in
  Logs.set_reporter reporter;
  app

let () =
  let open Lwt.Syntax in
  let _ = Dotenv.export () in
  match Server.run ~name:"todo" with
  | `Ok app ->
     let app' = init app in
     Lwt.async (fun () -> let* () = app' in Lwt.return_unit);
     Lwt_main.run (fst (Lwt.wait ()))
  | `Error -> exit 1
  | `Not_running -> exit 0
