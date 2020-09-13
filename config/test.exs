use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :financial_transactions, FinancialTransactions.Repo,
  username: System.get_env("DB_TEST_USER") || "postgres",
  password: System.get_env("DB_TEST_PASSWORD") || "postgres",
  database: System.get_env("DATABASE_TEST_DB") || "financial_transactions_dev_test",
  hostname: System.get_env("DB_TEST_HOST") || "localhost",
  port: System.get_env("DB_PORT") || 5432,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :financial_transactions, FinancialTransactionsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
