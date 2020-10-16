open Core

let to_ref f = fun fmt t -> f fmt !t

let timestamp fmt t =
  let str = Time.format ~zone:Time.Zone.utc t "%Y%m%d%H%M%S" in
  Caml.Format.pp_print_string fmt str
