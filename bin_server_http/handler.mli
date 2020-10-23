open Todo_http

module Todo: sig
  (** POST /todo *)
  val create : Endpoint.t

  (** PUT /todo/:id *)
  val update : Endpoint.t

  (** DELETE /todo/:id *)
  val delete : Endpoint.t

  (** GET /todo/:id *)
  val show : Endpoint.t

  (** GET /todo *)
  val index : Endpoint.t
end
