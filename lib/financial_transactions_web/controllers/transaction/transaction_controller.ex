defmodule FinancialTransactionsWeb.TransactionController do
  use FinancialTransactionsWeb, :controller
  alias FinancialTransactionsWeb.Transactions

  action_fallback FinancialTransactionsWeb.FallbackController

  def create(conn, %{"transaction" => transaction_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, operation} <- Transactions.create_transaction(transaction_params, user) do
      conn
      |> put_status(:created)
      |> render("transaction.json", transaction: operation.transaction_status_update)
    end
  end

end
