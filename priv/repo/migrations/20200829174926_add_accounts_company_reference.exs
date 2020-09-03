defmodule FinancialTransactions.Repo.Migrations.AddAccountsCompanyReference do
  use Ecto.Migration

  def change do
      alter table(:accounts) do
        add :company_id, references(:companies, on_delete: :delete_all, type: :binary_id)
      end
  end
end
