# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :ubg5, Ubg5Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GsPZiirkKfUZqDlxjwV//uTPsbcCxFiBnYs78N/QbzHaqMAxPOo1BzO+rPf7Jlle",
  render_errors: [view: Ubg5Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Ubg5.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix, :template_engines, exs: Temple.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
