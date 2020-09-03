defmodule FinancialTransactionsWeb.Transactions do
  def create_transaction(attrs, user) do
    FinancialTransactions.Tasks.CreateTransaction.run(attrs, user)
  end
end
