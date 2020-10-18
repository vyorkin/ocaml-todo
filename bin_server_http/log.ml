let get_level () =
  match Sys.getenv_opt "LOG_LEVEL" with
  | Some "error" -> Some Logs.Error
  | Some "info" -> Some Logs.Info
  | _ -> Some Logs.Debug

let default_reporter () =
  Fmt_tty.setup_std_outputs ();
  Logs.set_level @@ get_level ();
  Logs_fmt.reporter ()
