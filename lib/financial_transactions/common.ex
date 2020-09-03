defmodule FinancialTransactions.Common do
  alias FinancialTransactions.Accounts.{Account, Transaction}
  alias FinancialTransactions.Repo

  @spec unassoc_amounts(map) :: {any, map}
  def unassoc_amounts(attrs) do
    {amounts, attrs} = Map.pop(attrs, :amounts)
    if Enum.empty?(amounts) do
      {:error, "transaction must have at least one amount in assoc amounts list"}
    end
    {amounts, attrs}
  end

  def load_assoc_accounts(transaction) do
    transaction
    |> Repo.preload(:from_account)
    |> Repo.preload(:to_account)
  end

  def update_account_changeset(account, attrs) do
    account
    |> Account.changeset(attrs)
  end

  def update_transaction_changeset(transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
  end

  def has_credit?(account_balance, transaction_value) do
    account_balance > transaction_value
  end

  def update_transaction_amounts_changeset(transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
  end

end
