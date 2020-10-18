open Lwt.Syntax
open Core_kernel

let init app =
  let reporter = Log.default_reporter () in
  Logs.set_reporter reporter;
  app

let () =
  let _= Dotenv.export () in
  match Server.run ~name:"todo" with
  | `Ok app ->
     let app' = init app in
     Lwt.async (fun () -> let* () = app' in Lwt.return_unit);
     Lwt_main.run (fst (Lwt.wait ()))
  | `Error -> exit 1
  | `Not_running -> exit 0
