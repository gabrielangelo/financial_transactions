defmodule FinancialTransactions.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :password_hash, :string
      add :is_active, :boolean
      add :is_staff, :boolean

      timestamps()
    end
  end
end
