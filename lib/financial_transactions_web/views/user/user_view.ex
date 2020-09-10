defmodule FinancialTransactionsWeb.UserView do
  use FinancialTransactionsWeb, :view
  alias FinancialTransactionsWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("create_user.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        is_active: user.is_active,
        accounts: Enum.map(user.accounts, fn acc ->
          cond do
            %FinancialTransactions.Accounts.Account{} = acc ->
              acc.id
            true -> acc
          end
        end),
      }
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      is_active: user.is_active,
      accounts: Enum.map(user.accounts, &(&1.id))
    }
  end

end
