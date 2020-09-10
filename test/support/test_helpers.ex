defmodule FinancialTransactions.TestHelpers do
  alias FinancialTransactions.Companies.Company
  alias FinancialTransactions.Users.User
  alias FinancialTransactions.Accounts.Account

  alias FinancialTransactions.Repo

  import Plug.Conn
  alias FinancialTransactionsWeb.Guardian

  def build_attrs(:user_with_account_initial_value) do
    %{
      email: "test@gmail.com",
      first_name: "John",
      last_name: "Doe",
      password: "123456Gg",
      accounts: [
        %{
          name: "account with user",
          current_balance: 1000.0,
        },
      ],
    }
  end

  def build_attrs(:user_without_accounts) do
    %{
      email: "non_email@gmail.com",
      first_name: "Simon",
      last_name: "B.A Phanton",
      password: "123456Gg",
    }
  end

  def build_attrs(:user_with_account_non_initial_value) do
    %{
      email: "test@gmail.com",
      first_name: "John",
      last_name: "Doe",
      password: "123456Gg",
      accounts: [
        %{
          name: "account with user",
        },
      ],
    }
  end

  def build_attrs(:user_with_invalid_email) do
    %{
      email: "whatever",
      first_name: "John",
      last_name: "Doe",
      password: "123456Gg"
    }
  end

  def build_attrs(:company) do
    %{
      name: "stone",
      accounts: [
        %{name: "stone account", current_balance: Decimal.new(1000000000000000000000)},
      ],
    }
  end

  def build_attrs(:staff_user) do
    %{
      first_name: "Jack",
      last_name: "London",
      password: "123456Gg",
      is_staff: true,
      email: "staff@gmail.com"
    }
  end

  def company_fixture() do
    {:ok, company} =
    %Company{}
    |> Company.changeset(build_attrs(:company))
    |> Repo.insert

    company |> Repo.preload(:accounts)
  end

  @spec user_fixture(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) :: any
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
    user
  end

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert
    account
  end

  def authenticate(conn, user) do
    {:ok, token, _} = Guardian.encode_and_sign(user)
    put_req_header(conn, "authorization", "Bearer " <> token)
  end

  def build_authenticate_conns(conn) do
    staff_user = user_fixture(build_attrs(:staff_user))
    staff_conn = authenticate(conn, staff_user)

    non_staff_user =  user_fixture(build_attrs(:user_without_accounts))
    non_staff_conn = authenticate(conn, non_staff_user)

    {:ok,
      %{
        staff_conn: put_req_header(staff_conn, "accept", "application/json"),
        non_staff_conn: put_req_header(non_staff_conn, "accept", "application/json"),
        staff_user: staff_user,
        non_staff_user: non_staff_user
      }
    }
  end
end
