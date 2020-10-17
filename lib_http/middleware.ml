open Core_kernel
open Opium.Std
open Lwt.Infix

module Logging = struct
  open Httpaf

  let middleware =
    let filter handler req =
      handler req >|= fun res ->
      let meth = Method.of_string req.meth in
      let uri = req.target |> Uri.of_string |> Uri.path_and_query in
      let code = Status.to_string res.status in
      let zone = Time.get_sexp_zone () in
      let time = Time.to_sec_string ~zone Time.now () in
      Logs.info (fun m -> m "%s \"%s\" (%s) -> %s" meth uri time code);
      res
    in
    Rock.Middleware.create ~name:"Logging" ~filter

end

module Metrics = struct
  open Prometheus
end
