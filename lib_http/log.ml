let get_level () =
  match Sys.getenv_opt "LOG_LEVEL" with
  | Some "error" -> Some Logs.Error
  | Some "info" -> Some Logs.Info
  | _ -> Some Logs.Debug

let default_reporter () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_level @@ get_level ();
  Logs_fmt.reporter ()

let unhandled_error err =
  let msg = Printexc.to_string err in
  let stack = Printexc.get_backtrace () in
  Logs.err (fun m -> m "Unhandled error: %s\n%s" msg stack)
