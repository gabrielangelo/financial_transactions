# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :financial_transactions,
  ecto_repos: [FinancialTransactions.Repo]

# Configures the endpoint
config :financial_transactions, FinancialTransactionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Pal5vaYmKUo5COEGn937YcTICCv9+Ipw3PNiYZBQYyFuzxHZiWMQHVhT6o6QsAqc",
  render_errors: [view: FinancialTransactionsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FinancialTransactions.PubSub,
  live_view: [signing_salt: "KPo8aCZq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Guardian config
config :financial_transactions, FinancialTransactionsWeb.Guardian,
  issuer: "financial_transactions_web",
  secret_key: "JdBIjvtLw57V9HIofwe0C8Jy7UWYoXr1Qo49NCTmpit02NdoNtEFxiW5cRBLntDG"

config :financial_transactions, FinancialTransactionsWeb.AuthAccessPipeline,
  module: FinancialTransactionsWeb.Guardian,
  error_handler: FinancialTransactionsWeb.AuthErrorHandler
