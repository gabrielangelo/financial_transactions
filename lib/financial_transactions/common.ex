defmodule FinancialTransactions.Common do
  alias FinancialTransactions.Accounts.{Account, Transaction}
  alias FinancialTransactions.Repo

  def load_assoc_accounts(transaction) do
    transaction
    |> Repo.preload(:from_account)
    |> Repo.preload(:to_account)
  end

  def update_account_changeset(account, attrs) do
    account
    |> Account.changeset(attrs)
  end

  def has_credit?(account_balance, transaction_value) do
    cmp = Decimal.compare(account_balance, transaction_value)
    cmp in Enum.map(0..1, &(Decimal.new(&1)))
  end

  def update_transaction_amounts_changeset(transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
  end

end
