# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :do_it,
  ecto_repos: [DoIt.Repo]

# Configures the endpoint
config :do_it, DoItWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Xm/PwT4CZ6bOxUUGLTMpEsWsqLV684/+BfmA6u7sdik1g+sBaqJHAMgSp175rxpg",
  render_errors: [view: DoItWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DoIt.PubSub,
  live_view: [signing_salt: "asNIQbxA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
