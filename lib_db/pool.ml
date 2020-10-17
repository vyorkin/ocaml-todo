open Caqti_lwt

type 'e t =
  (connection, [> Caqti_error.connect] as 'e) Caqti_lwt.Pool.t

let make ~max_size url =
  url
  |> Uri.of_string
  |> connect_pool ~max_size
  |> function | Ok pool -> pool
              | Error err -> failwith (Caqti_error.show err)
