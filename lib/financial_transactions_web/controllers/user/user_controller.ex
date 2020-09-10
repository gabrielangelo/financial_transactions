defmodule FinancialTransactionsWeb.UserController do
  use FinancialTransactionsWeb, :controller

  alias FinancialTransactions.Users
  alias FinancialTransactions.Users.User

  action_fallback FinancialTransactionsWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, data} <- Users.create_user(user_params) do
        conn
        |> put_status(:created)
        |> render("create_user.json", user: data.user)
    end
  end

  def show(conn, %{"id" => id}) do
    case user = Users.get_user!(id) do
      %User{} -> render(conn, "show.json", user: user)
      nil -> {:error, :not_found}
    end
  end

  @spec update(any, map) :: any
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
