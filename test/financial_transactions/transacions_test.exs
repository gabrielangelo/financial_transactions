defmodule FinancialTransactions.TransactionsTest do
  use FinancialTransactions.DataCase
  import FinancialTransactions.TestHelpers
  alias FinancialTransactionsWeb.Transactions

  setup do
    user_one = user_with_account_fixture()
    user_two_attrs =  %{
      email: "testone@gmail.com",
      first_name: "Kate",
      last_name: "Doe",
      password: "123456Gg",
      accounts: [
        %{
          name: "account with user",
        },
      ],
    }

    user_two = user_with_account_fixture(user_two_attrs)
    {:ok, [user_one: user_one, user_two: user_two]}
  end

  describe "transactions" do
    test "test internal transfer case", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)
      user_two = context[:user_two]
      user_two_account = List.first(user_two.accounts)

      transaction_attrs = %{
        description: "Xbox One buying",
        type: "transfer",
        from_account_id: user_one_account.id,
        to_account_id: user_two_account.id,
        value: 1000.0,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit",
          },
          %{
            amount: 1000.0,
            type: "credit",
          },
        ]
      }

      {:ok, data_process} = Transactions.create_transaction(transaction_attrs, user_one)
      user_one_account_after_transaction = data_process.from_account_update
      user_two_account_after_transaction = data_process.to_account_update
      transaction = data_process.transaction_status_update

      assert  Decimal.compare(
        user_one_account_after_transaction.current_balance,
        Decimal.new(0)
      ) == Decimal.new(0)

      assert Decimal.compare(
        user_two_account_after_transaction.current_balance,
        Decimal.new(2000)
      ) == Decimal.new(0)

      assert transaction.status == 1
      assert Enum.empty?(transaction.amounts) == false

      Enum.map(transaction.amounts, fn amount ->
        cond do
          amount.type == "credit" ->
            assert amount.account_id == transaction_attrs.to_account_id

          amount.type == "debit" ->
            assert amount.account_id == transaction_attrs.from_account_id
          true ->
            assert Decimal.compare(
              amount.amount,
              Decimal.from_float(transaction_attrs.value)) == Decimal.new(0)
            assert amount.transaction_id == transaction.id
        end

      end)

    end

    test "test withdraw case", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "Withdrawall 1000 #currency#",
        type: "withdraw",
        from_account_id: user_one_account.id,
        value: 1000.0,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit",
          },
        ]
      }

      {:ok, data_process} = Transactions.create_transaction(transaction_attrs, user_one)

      user_one_account_after_transaction = data_process.from_account_update

      assert  Decimal.compare(
        user_one_account_after_transaction.current_balance,
        Decimal.new(0)
      ) == Decimal.new(0)

      transaction = data_process.transaction_status_update

      Enum.map(transaction.amounts, fn amount ->
        assert amount.account_id == transaction_attrs.from_account_id
        assert Decimal.compare(
          amount.amount, Decimal.from_float(transaction_attrs.value)) == Decimal.new(0)
        assert amount.transaction_id == transaction.id
      end)

    end

  end
end
