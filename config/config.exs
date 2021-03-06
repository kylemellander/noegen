# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :noegen,
  ecto_repos: [Noegen.Repo]

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures the endpoint
config :noegen, Noegen.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RBl442oGaJ5KSoV4bj6zo7wAAcRQ1ee+T2HflTVccDO4hK0PcSbM29kBgsuBWq+2",
  render_errors: [view: Noegen.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Noegen.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Noegen",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  serializer: Noegen.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
