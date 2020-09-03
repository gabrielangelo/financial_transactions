defmodule FinancialTransactions.Tasks.Managers do
  alias FinancialTransactions.Common, as: Common
  alias Ecto.Multi
  alias FinancialTransactions.Repo

  def external_transfer(transaction, amount_attrs, from_account) do
    case Multi.new()
      |> Multi.update(:from_account_update, Common.update_account_changeset(
        from_account,
        %{current_balance: Decimal.sub(from_account.current_balance, transaction.value)}
      ))

      |> Multi.update(:transaction_status_update, Common.update_transaction_amounts_changeset(
        transaction,
        %{amounts: amount_attrs, status: 1})
      ) |>  Repo.transaction do
        {:ok, item} -> {:ok, item}
      end
  end

  def withdraw(transaction, amount_attrs, from_account) do
    Multi.new()
    |> Multi.update(:from_account_update, Common.update_account_changeset(
      from_account,
      %{current_balance: Decimal.sub(from_account.current_balance, transaction.value)}
    ))

    |> Multi.update(:transaction_update, Common.update_transaction_amounts_changeset(
        transaction,
        %{amounts: amount_attrs, status: 1}
      )
    )
    |> Repo.transaction

  end

  def internal_transfer(transaction, amount_attrs, from_account, to_account) do
    Multi.new()
      |> Multi.update(:from_account_update, Common.update_account_changeset(
        from_account,
        %{current_balance: Decimal.sub(from_account.current_balance, transaction.value)}
      ))

      |> Multi.update(:to_account_update, Common.update_account_changeset(
        to_account,
        %{current_balance: Decimal.add(to_account.current_balance, transaction.value)}
      ))

      |> Multi.update(:transaction_status_update, Common.update_transaction_amounts_changeset(
        transaction,
        %{amounts: amount_attrs, status: 1})
      )
      |>  Repo.transaction
  end
end
