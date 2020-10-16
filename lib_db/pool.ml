open Caqti_lwt

let make url ?(max_size = 10) =
  match connect_pool ~max_size (Uri.of_string url) with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)
