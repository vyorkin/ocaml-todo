let unhandled_error err =
  let msg = Printexc.to_string err in
  let stack = Printexc.get_backtrace () in
  Logs.err (fun m -> m "Unhandled exception: %s\n%s" msg stack)
