defmodule FinancialTransactions.Repo.Migrations.TransactionAddEmitAtField do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :emit_at, :date, default: Date.to_iso8601(Date.utc_today)
    end
  end
end
