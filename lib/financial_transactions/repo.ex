defmodule FinancialTransactions.Repo do
  use Ecto.Repo,
    otp_app: :financial_transactions,
    adapter: Ecto.Adapters.Postgres
end
