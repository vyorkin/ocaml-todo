open Opium.Std
open Todo_http

type 'a status = [> `Ok of unit Lwt.t | `Error | `Not_running] as 'a

let add_middleware app =
  app
  |> middleware Middleware.logging

let add_routes app =
  let open Handler in
  app
  |> get "/todo" Todo.index
  |> get "/todo/:id" Todo.show
  (* |> post "/todo" Todo.create
   * |> put "/todo/:id" Todo.update
   * |> delete "/todo/:id" Todo.destroy *)

let init app =
  app
  |> add_middleware
  |> add_routes

let get_port () =
 "HTTP_PORT"
  |> Sys.getenv_opt
  |> Option.map int_of_string
  |> Option.value ~default:8081

let run ~name =
  let port = get_port () in
  App.empty
  |> App.cmd_name name
  |> App.port port
  |> init
  |> App.run_command'
