defmodule FinancialTransactions.AccountsTest do
  use FinancialTransactions.DataCase

  alias FinancialTransactions.Accounts

  describe "accounts" do
    alias FinancialTransactions.Accounts.Account

    @valid_attrs %{acc_number: "some acc_number", ag_number: "some ag_number", current_balance: "120.5"}
    @update_attrs %{acc_number: "some updated acc_number", ag_number: "some updated ag_number", current_balance: "456.7"}
    @invalid_attrs %{acc_number: nil, ag_number: nil, current_balance: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.acc_number == "some acc_number"
      assert account.ag_number == "some ag_number"
      assert account.current_balance == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.acc_number == "some updated acc_number"
      assert account.ag_number == "some updated ag_number"
      assert account.current_balance == Decimal.new("456.7")
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "transactions" do
    alias FinancialTransactions.Accounts.Account

    @valid_attrs %{email_notification_status: 42, is_external: true, transaction_status: 42, type: 42, value: "120.5"}
    @update_attrs %{email_notification_status: 43, is_external: false, transaction_status: 43, type: 43, value: "456.7"}
    @invalid_attrs %{email_notification_status: nil, is_external: nil, transaction_status: nil, type: nil, value: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_transactions/0 returns all transactions" do
      account = account_fixture()
      assert Accounts.list_transactions() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.email_notification_status == 42
      assert account.is_external == true
      assert account.transaction_status == 42
      assert account.type == 42
      assert account.value == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.email_notification_status == 43
      assert account.is_external == false
      assert account.transaction_status == 43
      assert account.type == 43
      assert account.value == Decimal.new("456.7")
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
