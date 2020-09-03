defmodule FinancialTransactions.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :is_active, :boolean

      timestamps()
    end
  end
end
