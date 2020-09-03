defmodule FinancialTransactionsWeb.SignInView do
  use FinancialTransactionsWeb, :view

  def render("login.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end
end
