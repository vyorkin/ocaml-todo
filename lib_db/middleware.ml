open Opium
open Opium.Std

module Env = struct
  open Hmap
  open Sexplib.Std

  let pool_key : _ Pool.t key =
    Key.create ("db_pool", fun _ -> sexp_of_string "db_pool")
end

let make ?(pool_size = 10) ~url =
  let pool = Pool.make ~max_size:pool_size url in
  let filter handler (req: Request.t) =
    let env = Hmap.add Env.pool_key pool req.env in
    handler { req with env }
  in
  Rock.Middleware.create
    ~name:"Database connection pool"
    ~filter

let pool (req : Request.t) : [> Caqti_error.connect] Pool.t =
  Hmap.find_exn Env.pool_key req.env
