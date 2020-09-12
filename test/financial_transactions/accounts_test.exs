defmodule FinancialTransactions.AccountsTest do
  use FinancialTransactions.DataCase

  alias FinancialTransactions.Accounts

  import FinancialTransactions.TestHelpers

  describe "accounts" do
    alias FinancialTransactions.Accounts.Account

    setup do
      user = user_fixture(build_attrs(:user_without_accounts))

      valid_account_attrs = %{
        name: "test account",
        user_id: user.id
      }

      invalid_account_attrs = %{
        name: "test account"
      }

      {:ok,
       user: user,
       valid_account_attrs: valid_account_attrs,
       invalid_account_attrs: invalid_account_attrs}
    end

    test "list_accounts/0 returns all accounts", %{valid_account_attrs: valid_account_attrs} do
      account = account_fixture(valid_account_attrs)
      assert Enum.map(Accounts.list_accounts(), & &1.id) == [account.id]
    end

    test "get_account!/1 returns the account with given id", %{
      valid_account_attrs: valid_account_attrs
    } do
      account = account_fixture(valid_account_attrs)
      assert Accounts.get_account!(account.id).id == account.id
    end

    test "create_account/1 with valid data creates a account", %{
      valid_account_attrs: valid_account_attrs
    } do
      account = account_fixture(valid_account_attrs)

      assert account.name == valid_account_attrs.name
      assert account.current_balance == 0.0
    end

    test "create_account/1 with invalid data returns error changeset", %{
      invalid_account_attrs: invalid_account_attrs
    } do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.create_account(invalid_account_attrs)

      assert changeset.errors == [
               company_id: {"Account must be vinculated at least one user or company", []}
             ]
    end

    test "update_account/2 with valid data updates the account", %{
      valid_account_attrs: valid_account_attrs
    } do
      account = account_fixture(valid_account_attrs)

      update_attrs = %{
        name: "updated name",
        current_balance: 2.00
      }

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.name == update_attrs.name
      assert account.current_balance == Decimal.from_float(update_attrs.current_balance)
    end

    test "delete_account/1 deletes the account", %{valid_account_attrs: valid_account_attrs} do
      account = account_fixture(valid_account_attrs)
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end
  end
end
