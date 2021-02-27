defmodule MyTelemetryApi.Repo do
  use Ecto.Repo,
    otp_app: :my_telemetry_api,
    adapter: Ecto.Adapters.Postgres
end
