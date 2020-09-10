defmodule FinancialTransactionsWeb.AccountView do
  use FinancialTransactionsWeb, :view
  alias FinancialTransactionsWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id,
      name: account.name,
      user_id: account.user_id,
      company_id: account.company_id
    }
  end
end
