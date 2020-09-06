defmodule FinancialTransactions.Tasks.CreateTransaction do
  @moduledoc """
  The Transactions context.
  """

  alias FinancialTransactions.Repo
  alias FinancialTransactions.Accounts.Transaction
  alias FinancialTransactions.Tasks.{MakeTransfer, MakeWithdraw}
  alias FinancialTransactions.Users.User
  alias FinancialTransactions.Companies.Company

  defp transaction_changeset(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
  end

  defp process_transaction(
    %Transaction{type: "transfer"} = transaction,
    amount_attrs
  ) do
    MakeTransfer.run(transaction, amount_attrs)
  end

  defp process_transaction(
    %Transaction{type: "withdraw"} = transaction,
    amount_attrs
  ) do
    MakeWithdraw.run(transaction, amount_attrs)
  end

  defp unpack_amounts(attrs) do
    case Map.pop(attrs, :amounts) do
      {nil, attrs} -> Map.pop(attrs, "amounts")
      {amounts, transaction_changeset} -> {amounts, transaction_changeset}
    end

  end

  def run(attrs, user \\ %User{}, company \\ %Company{}) do
    {amount_attrs, transacion_attrs} = unpack_amounts(attrs)

    transaction_changeset = transaction_changeset(transacion_attrs)

    if transaction_changeset.valid? do
      user_accounts_ids = Enum.map(user.accounts, fn account -> account.id end)

      company_account_ids = company
      |> Repo.preload(:accounts)
      |> Map.get(:accounts, [])
      |> Enum.map(&(&1.id))

      cond do
        transaction_changeset.changes.from_account_id not in user_accounts_ids ++ company_account_ids ->
          {:error, Ecto.Changeset.add_error(
            transaction_changeset,
            :from_account_id,
            "Account doesn't belong to request user")
          }

        amount_attrs == nil || amount_attrs == [] ->
          {:error, Ecto.Changeset.add_error(
            transaction_changeset,
            :amounts,
            "Transaction cannot have amounts")
          }

        {:ok, transaction} = transaction_changeset |> Repo.insert ->
          case process_transaction(transaction, amount_attrs) do
            {:ok, transaction_items} -> {:ok, transaction_items}

            {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}

            {:error, :invalid_balance} -> {:error, :invalid_balance}
          end
      end

    else
      {:error, transaction_changeset}
    end
  end
end
