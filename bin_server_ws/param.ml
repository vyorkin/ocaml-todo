open Core_kernel

let unit _ = ()

let id = function
  | s :: _ -> int_of_string s
  | _ -> failwith "id parameter missing"

let json decode data =
  data |> List.hd_exn |> decode

let id_json decode to_record list =
  match list with
  | s1 :: s2 :: _ ->
     let id' = id [ s1 ] in
     let data = json decode [ s2 ] in
     to_record (id', data)
  | _ -> failwith "id or json parameters are missing"
