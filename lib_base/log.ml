let get_level () =
  match Sys.getenv_opt "LOG_LEVEL" with
  | Some "error" -> Logs.Error
  | Some "info" -> Logs.Info
  | _ -> Logs.Debug

let make_reporter ~verbose =
  Fmt_tty.setup_std_outputs ();
  let level =
    if verbose
    then Logs.Debug
    else get_level ()
  in
  Logs.set_level (Some level);
  Logs_fmt.reporter ()

let unhandled_error err =
  let msg = Printexc.to_string err in
  let stack = Printexc.get_backtrace () in
  Logs.err (fun m -> m "Unhandled error: %s\n%s" msg stack)
