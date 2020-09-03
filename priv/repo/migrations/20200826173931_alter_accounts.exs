defmodule FinancialTransactions.Repo.Migrations.AlterAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :current_balance, :decimal, default: 0.0
    end
  end
end
