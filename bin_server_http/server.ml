open Opium.Std
open Todo_http

let add_middleware app =
  app
  |> middleware Middleware.logging

let add_routes app =
  let open Handler in
  app
  |> get "/todo" Todo.index
  |> get "/todo/:id" Todo.show
  |> post "/todo" Todo.create
  |> put "/todo/:id" Todo.update
  |> delete "/todo/:id" Todo.destroy

let init app =
  app
  |> add_middleware
  |> add_routes

let run () =
  App.empty
  |> init
  |> App.run_command'
