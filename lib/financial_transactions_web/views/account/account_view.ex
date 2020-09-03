defmodule FinancialTransactionsWeb.AccountView do
  use FinancialTransactionsWeb, :view
  alias FinancialTransactionsWeb.AccountView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    account_data = %{id: account.id,
      value: account.value,
      type: account.type,
      is_external: account.is_external,
      transaction_status: account.transaction_status,
      email_notification_status: account.email_notification_status
    }
    %{
      data: account_data
    }
  end
end
