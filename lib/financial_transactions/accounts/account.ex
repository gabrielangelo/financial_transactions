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
    |> cast(attrs, [:name, :user_id, :current_balance, :is_active])
    |> validate_required([:name])
    |> validate_number(:current_balance, greater_than_or_equal_to: 0)
    |> assoc_constraint(:user)
  end

  def single_create_changeset(%__MODULE__{} = account, attrs) do
    account
    |> cast(attrs, [:name, :user_id, :company_id, :is_active])
    |> validate_required([:name])
    |> validate_number(:current_balance, greater_than_or_equal_to: 0)
    |> check_referencies
  end

  defp check_referencies(%Ecto.Changeset{changes: %{user_id: _user_id}} = changeset) do
    changeset
  end

  defp check_referencies(%Ecto.Changeset{changes: %{company_id: _company_id}} = changeset) do
    changeset
  end

  defp check_referencies(changeset) do
    add_error(changeset, :user_id, "Account must be vinculated at least one user or company")
    add_error(changeset, :company_id, "Account must be vinculated at least one user or company")
  end

end
