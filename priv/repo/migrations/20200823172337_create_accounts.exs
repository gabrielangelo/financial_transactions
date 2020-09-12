defmodule FinancialTransactions.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_active, :boolean
      add :name, :string
      add :current_balance, :decimal

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end
  end
end
