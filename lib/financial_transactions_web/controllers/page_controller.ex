defmodule FinancialTransactionsWeb.PageController do
  use FinancialTransactionsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
