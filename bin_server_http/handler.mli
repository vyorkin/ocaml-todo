open Todo_http

module Todo: sig
  (** GET /todo/:id *)
  val show : Endpoint.t

  (** GET /todo *)
  val index : Endpoint.t
end
