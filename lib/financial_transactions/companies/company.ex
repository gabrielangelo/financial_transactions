defmodule FinancialTransactions.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "companies" do
    field :name, :string
    field :is_active, :boolean, default: true

    # associations
    has_many :accounts, FinancialTransactions.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = account, attrs) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:accounts, with: &FinancialTransactions.Accounts.Account.changeset/2)
    |> unique_constraint(:name)
  end
end
