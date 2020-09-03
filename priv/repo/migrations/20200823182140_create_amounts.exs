defmodule FinancialTransactions.Repo.Migrations.CreateAmounts do
  use Ecto.Migration

  def change do
    create table(:amounts, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :amount, :decimal
      add :type, :string

      add :transaction_id, references(:transactions, on_delete: :nothing, type: :binary_id)
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

  end
end
