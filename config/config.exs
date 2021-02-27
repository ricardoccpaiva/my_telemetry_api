# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_telemetry_api,
  ecto_repos: [MyTelemetryApi.Repo]

# Configures the endpoint
config :my_telemetry_api, MyTelemetryApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9iw2zOBXt2MyZ+hwpNutbsoBfrHv6aCfY6zrFxe1MkDHH/l4JZBripP0qwjoU/bX",
  render_errors: [view: MyTelemetryApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MyTelemetryApi.PubSub,
  live_view: [signing_salt: "2Y/wqPLm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
