open Todo_http

module Todo: sig
  (** POST /todo *)
  val create : Endpoint.handler

  (** PUT /todo/:id *)
  val update : Endpoint.handler

  (** DELETE /todo/:id *)
  val delete : Endpoint.handler

  (** GET /todo/:id *)
  val show : Endpoint.handler

  (** GET /todo *)
  val index : Endpoint.handler
end
