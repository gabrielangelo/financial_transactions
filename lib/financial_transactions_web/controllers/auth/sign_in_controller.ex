defmodule FinancialTransactionsWeb.SignInController do
  use FinancialTransactionsWeb, :controller
  alias FinancialTransactionsWeb.Guardian

  def create(conn, %{"email" => email, "password" => password}) do
    case FinancialTransactions.Tasks.SignIn.run(email, password) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)
        render(conn, "login.json", %{token: token})

      {:error, _} ->
        conn
        |> put_status(401)
        |> json(%{status: "unauthenticated"})
    end
  end
end
