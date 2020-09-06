defmodule FinancialTransactions.UsersTest do
  use FinancialTransactions.DataCase

  alias FinancialTransactions.Users
  import FinancialTransactions.TestHelpers

  describe "users" do

    @initial_value Decimal.from_float(1000.0)

    @user_with_account_attrs build_attrs(:user_with_account)
    @user_with_invalid_email build_attrs(:user_with_invalid_email)

    test "test the basic user creation with associated account which initial balance starts with R$1000.0" do
      company_fixture()

      {:ok, data} = Users.create_user(@user_with_account_attrs)
      user = data.user
      account = data.account

      assert user.first_name ==  @user_with_account_attrs.first_name
      assert user.last_name == @user_with_account_attrs.last_name
      assert user.email == @user_with_account_attrs.email
      assert Bcrypt.verify_pass(@user_with_account_attrs.password, user.password_hash) == true
      assert account.user_id == user.id
      assert Decimal.compare(account.current_balance, @initial_value) == Decimal.new(0)
    end

    test "test invalid email input" do
      {:error, changeset} = Users.create_user(@user_with_invalid_email)
      assert changeset.valid? == false
      [email: _] = changeset.errors
    end

    test "test user creation without main company account" do

      {:error, changeset} = Users.create_user(@user_with_account_attrs)
      assert changeset.valid? == false
      [from_account_id: _] = changeset.errors
    end

    test "test unique user email constraint" do
      company_fixture()
      Users.create_user(@user_with_account_attrs)
      {:error, changeset} = Users.create_user(@user_with_account_attrs)
      assert changeset.valid? == false
      [email: _] = changeset.errors
    end

  end
end
