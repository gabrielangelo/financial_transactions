defmodule FinancialTransactions.TestHelpers do
  alias FinancialTransactions.Companies.Company
  alias FinancialTransactions.Users.User
  alias FinancialTransactions.Repo
  alias FinancialTransactions.Users

  def build_attrs(:user_with_account) do
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

  def company_fixture() do
    {:ok, company} =
    %Company{}
    |> Company.changeset(build_attrs(:company))
    |> Repo.insert

    company |> Repo.preload(:accounts)
  end

  def user_with_account_fixture(attrs \\ build_attrs(:user_with_account)) do
    company_fixture()
    {:ok, data} = Users.create_user(attrs)
    data.user
  end

end