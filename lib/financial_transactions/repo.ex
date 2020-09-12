defmodule FinancialTransactions.Repo do
  use Ecto.Repo,
    otp_app: :financial_transactions,
    adapter: Ecto.Adapters.Postgres

    def init(_, config) do
      config = config
        |> Keyword.put(:username, System.get_env("DB_USER") || "postgres")
        |> Keyword.put(:password, System.get_env("DB_PASSWORD") || "postgres")
        |> Keyword.put(:database, System.get_env("DATABASE_DB") || "financial_transactions_dev")
        |> Keyword.put(:hostname, System.get_env("DB_HOST") || "localhost")
        |> Keyword.put(:port, System.get_env("DB_PORT") || 5432)
      {:ok, config}
    end
end
