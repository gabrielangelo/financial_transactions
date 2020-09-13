defmodule FinancialTransactions.Accounts.Amount do
  @moduledoc """
  Amounts schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @amount_types ["credit", "debit"]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "amounts" do
    field :amount, :decimal
    field :type, :string

    belongs_to :transaction, FinancialTransactions.Accounts.Transaction
    belongs_to :account, FinancialTransactions.Accounts.Account

    timestamps()
  end

  def changeset(%__MODULE__{} = amount, attrs \\ %{}) do
    amount
    |> cast(attrs, [:amount, :type, :account_id])
    |> validate_required([:amount, :type])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_inclusion(:type, @amount_types)
    |> assoc_constraint(:account)
    |> assoc_constraint(:transaction)
  end
end
