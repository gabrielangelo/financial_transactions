defmodule FinancialTransactions.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "accounts" do
    field :name, :string
    field :current_balance, :decimal, default: 0.0
    field :is_active, :boolean, default: true

    # associations
    belongs_to :user, FinancialTransactions.Users.User
    belongs_to :company, FinancialTransactions.Companies.Company

    has_many :amounts, FinancialTransactions.Accounts.Amount

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = account, attrs) do
    account
    |> cast(attrs, [:name, :user_id, :current_balance])
    |> validate_required([:name])
    |> validate_number(:current_balance, greater_than_or_equal_to: 0)
    |> assoc_constraint(:user)
  end

end
