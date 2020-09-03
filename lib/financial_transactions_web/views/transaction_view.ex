defmodule FinancialTransactionsWeb.TransactionView do
  use FinancialTransactionsWeb, :view

  def render("transaction.json", %{transaction: transaction}) do
    transaction_data = %{
      id: transaction.id,
      description: transaction.description,
      status: transaction.status,
      value: transaction.value,
      amounts: Enum.map(transaction.amounts, fn account -> account |> Map.take([:id, :type, :amount]) end),
      to_account_id: transaction.to_account_id,
      from_account_id: transaction.from_account_id
    }

    %{data: transaction_data}
  end
end
