defmodule MyTelemetryApi.Gateways.Http do
  def get(client, status) do
    params = [status: status]
    Tesla.get(client, "/:status", opts: [path_params: params])
  end

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://http.cat/"},
      Tesla.Middleware.Telemetry,
      Tesla.Middleware.PathParams,
      {Tesla.Middleware.Query, [token: "some-token"]}
    ]

    Tesla.client(middleware)
  end
end
