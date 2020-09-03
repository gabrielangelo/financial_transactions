defmodule FinancialTransactionsWeb.UserView do
  use FinancialTransactionsWeb, :view
  alias FinancialTransactionsWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      is_active: user.is_active,
      accounts: Enum.map(user.accounts, fn account -> account |> Map.take([:id]) end)
    }
  end
end
