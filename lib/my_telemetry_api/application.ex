defmodule MyTelemetryApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    OpentelemetryPhoenix.setup()
    OpentelemetryEcto.setup([:my_telemetry_api, :repo])
    OpentelemetryTesla.setup()

    children = [
      # Start the Ecto repository
      MyTelemetryApi.Repo,
      # Start the Telemetry supervisor
      MyTelemetryApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MyTelemetryApi.PubSub},
      # Start the Endpoint (http/https)
      MyTelemetryApiWeb.Endpoint
      # Start a worker by calling: MyTelemetryApi.Worker.start_link(arg)
      # {MyTelemetryApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyTelemetryApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MyTelemetryApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
