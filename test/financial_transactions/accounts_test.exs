defmodule FinancialTransactions.AccountsTest do
  use FinancialTransactions.DataCase

  alias FinancialTransactions.Accounts

  describe "accounts" do
    alias FinancialTransactions.Accounts.Account
    alias FinancialTransactions.Repo

    @account_attrs %{name: "account test name", current_balance: "120.5"}
    @update_attrs %{current_balance: "456.7"}
    @invalid_attrs %{current_balance: nil}


    def account_without_user_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@account_attrs)
        |> Accounts.create_account()
      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_without_user_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_without_user_fixture()
      assert Accounts.get_account!(account.id) == account

    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@account_attrs)
      assert account.name == "account test name"
      assert account.current_balance == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_without_user_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.name == "account test name"
      assert account.current_balance == Decimal.new("456.7")
    end


    test "delete_account/1 deletes the account" do
      account = account_without_user_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_without_user_fixture(@account_attrs)
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

end
