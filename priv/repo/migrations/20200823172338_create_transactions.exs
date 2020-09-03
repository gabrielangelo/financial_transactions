defmodule FinancialTransactions.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_external, :boolean, default: false, null: false
      add :status, :integer, default: 0
      add :email_notification_status, :integer, default: 0
      add :description, :string
      add :type, :string
      add :value, :decimal

      add :from_account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)
      add :to_account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)
      timestamps()

    end
  end
end
