let run query connection =
  let (module C : Caqti_lwt.CONNECTION) = connection in
  let%lwt _ = C.start () in
  match%lwt query connection with
  | Ok result ->
     let%lwt _ = C.commit () in
     Lwt.return (Ok result)
  | Error error ->
     let%lwt _ = C.rollback () in
     Lwt_result.fail error
