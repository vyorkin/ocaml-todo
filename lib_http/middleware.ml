open Core
open Lwt.Infix
open Opium.Std

let logging =
  let filter handler (req: Request.t) =
    handler req >|= fun (res: Response.t) ->
    let meth = Httpaf.Method.to_string req.meth in
    let uri = req.target |> Uri.of_string |> Uri.path_and_query in
    let code = Httpaf.Status.to_string res.status in
    let zone = Time.get_sexp_zone () in
    let time = Time.now () |> Time.to_sec_string ~zone in
    Logs.info (fun m -> m "%s \"%s\" (%s) -> %s" meth uri time code);
    res
  in
  Rock.Middleware.create ~name:"Logging" ~filter

let metrics =
  (* TODO: Continue from here *)
  (* let ... in *)
  Rock.Middleware.create ~name:"Logging" ~filter
