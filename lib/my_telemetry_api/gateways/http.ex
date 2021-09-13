defmodule MyTelemetryApi.Gateways.Http do
  def get(client, status) do
    Tesla.get(client, "/cats", opts: [])
  end

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:4001/api"},
      Tesla.Middleware.OpenTelemetry,
      Tesla.Middleware.Telemetry,
      {Tesla.Middleware.Query, [token: "some-token"]}
    ]

    Tesla.client(middleware)
  end
end
