defmodule FinancialTransactions.TransactionsTest do
  use FinancialTransactions.DataCase
  import FinancialTransactions.TestHelpers
  alias FinancialTransactions.Transactions

  setup do
    user_one = user_fixture(build_attrs(:user_with_account_initial_value))

    user_two_attrs = %{
      email: "testone@gmail.com",
      first_name: "Kate",
      last_name: "Doe",
      password: "123456Gg",
      accounts: [
        %{
          name: "account with user",
          current_balance: 1000.0
        }
      ]
    }

    user_two = user_fixture(user_two_attrs)
    {:ok, [user_one: user_one, user_two: user_two]}
  end

  describe "transactions" do
    test "test internal transfer case", context do
      company_fixture()
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
            type: "debit"
          },
          %{
            amount: 1000.0,
            type: "credit"
          }
        ]
      }

      {:ok, data_process} = Transactions.create_transaction(transaction_attrs, user_one)
      user_one_account_after_transaction = data_process.from_account_update
      user_two_account_after_transaction = data_process.to_account_update
      transaction = data_process.transaction_status_update

      assert Decimal.compare(
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
                     Decimal.from_float(transaction_attrs.value)
                   ) == Decimal.new(0)

            assert amount.transaction_id == transaction.id
        end
      end)
    end

    test "test withdraw case", context do
      company_fixture()
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
            type: "debit"
          }
        ]
      }

      {:ok, data_process} = Transactions.create_transaction(transaction_attrs, user_one)

      user_one_account_after_transaction = data_process.from_account_update

      assert Decimal.compare(
               user_one_account_after_transaction.current_balance,
               Decimal.new(0)
             ) == Decimal.new(0)

      transaction = data_process.transaction_status_update

      Enum.map(transaction.amounts, fn amount ->
        assert amount.account_id == transaction_attrs.from_account_id

        assert Decimal.compare(amount.amount, Decimal.from_float(transaction_attrs.value)) ==
                 Decimal.new(0)

        assert amount.transaction_id == transaction.id
      end)
    end

    test "external transaction case", context do
      company_fixture()
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "Nba pistons t-shirt buying",
        type: "transfer",
        is_external: true,
        from_account_id: user_one_account.id,
        value: 200.0,
        amounts: [
          %{
            amount: 200.0,
            type: "debit"
          }
        ]
      }

      {:ok, data_process} = Transactions.create_transaction(transaction_attrs, user_one)

      user_one_account_after_transaction = data_process.from_account_update

      assert Decimal.compare(
               user_one_account_after_transaction.current_balance,
               Decimal.new(800)
             ) == Decimal.new(0)

      transaction = data_process.transaction_status_update

      Enum.map(transaction.amounts, fn amount ->
        assert amount.account_id == transaction_attrs.from_account_id

        assert Decimal.compare(amount.amount, Decimal.from_float(transaction_attrs.value)) ==
                 Decimal.new(0)

        assert amount.transaction_id == transaction.id
      end)
    end

    test "test withdraw with value greather than account current balance", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "Nba pistons t-shirt buying",
        type: "withdraw",
        from_account_id: user_one_account.id,
        value: 2000.0,
        amounts: [
          %{
            amount: 2000.0,
            type: "debit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false

      assert changeset.errors == [
               value: {"insufficient funds", []}
             ]
    end

    test "test internal transfer  with value greather than account current balance", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      user_two = context[:user_two]
      user_two_account = List.first(user_two.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "transfer",
        from_account_id: user_one_account.id,
        to_account_id: user_two_account.id,
        value: 2000.0,
        amounts: [
          %{
            amount: 2000.0,
            type: "debit"
          },
          %{
            amount: 2000.0,
            type: "credit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false

      assert changeset.errors == [
               value: {"insufficient funds", []}
             ]
    end

    test "test external transfer  with value greather than account current balance", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "transfer",
        from_account_id: user_one_account.id,
        is_external: true,
        value: 2000.0,
        amounts: [
          %{
            amount: 2000.0,
            type: "debit"
          },
          %{
            amount: 2000.0,
            type: "credit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false
      assert changeset.errors == [value: {"insufficient funds", []}]
    end

    test "test transfer with amounts value different from transaction value", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "transfer",
        from_account_id: user_one_account.id,
        to_account_id: user_one_account.id,
        value: 1000.0,
        is_external: false,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit"
          },
          %{
            amount: 1001.0,
            type: "credit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false

      assert changeset.errors == [
               amounts:
                 {"transaction value and amount values (credit and debit) must be equals", []}
             ]
    end

    test "test withdraw with credit amount", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "withdraw",
        from_account_id: user_one_account.id,
        to_account_id: user_one_account.id,
        value: 1000.0,
        is_external: false,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit"
          },
          %{
            amount: 1000.0,
            type: "credit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false
      assert changeset.errors == [amounts: {"withdraw operation can't have credit amounts", []}]
    end

    test "test withdraw as external transfer", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "withdraw",
        from_account_id: user_one_account.id,
        to_account_id: user_one_account.id,
        value: 1000.0,
        is_external: true,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false

      assert changeset.errors == [
               is_external: {"external transaction cannot have to_account_id field", []}
             ]
    end

    test "test external transaction transfer with credit amount", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "transfer",
        from_account_id: user_one_account.id,
        value: 1000.0,
        is_external: true,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit"
          },
          %{
            amount: 1000.0,
            type: "credit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false

      assert changeset.errors == [
               amounts: {"external transaction cannot have credit amounts", []}
             ]
    end

    test "tests external transfer with to_accuont_id", context do
      user_one = context[:user_one]
      user_one_account = List.first(user_one.accounts)

      user_two = context[:user_two]
      user_two_account = List.first(user_two.accounts)

      transaction_attrs = %{
        description: "transfer to kate",
        type: "transfer",
        from_account_id: user_one_account.id,
        to_account_id: user_two_account.id,
        value: 1000.0,
        is_external: true,
        amounts: [
          %{
            amount: 1000.0,
            type: "debit"
          }
        ]
      }

      {:error, changeset} = Transactions.create_transaction(transaction_attrs, user_one)
      assert changeset.valid? == false

      assert changeset.errors == [
               is_external: {"external transaction cannot have to_account_id field", []}
             ]
    end
  end
end
