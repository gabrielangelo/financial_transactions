defmodule FinancialTransactions.TransactionsControllerTest do
  use FinancialTransactionsWeb.ConnCase

  import FinancialTransactions.TestHelpers

  setup %{conn: conn} do
    {:ok, data} = build_authenticate_conns(conn)
    %{non_staff_user: non_staff_user} = data

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

    account_attrs = %{
      name: "accunt non staff",
      user_id: non_staff_user.id,
      current_balance: 1000.0
    }

    account_one = account_fixture(account_attrs)
    account_two = List.first(user_two.accounts)
    data = Map.merge(data, %{user_one_account: account_one, user_two_account: account_two})

    {:ok, data}
  end

  describe "index" do
    test "tests index transaciton", %{
      non_staff_conn: conn,
      user_one_account: user_one_account,
      user_two_account: user_two_account
    } do
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
            amount: 500.0,
            type: "credit"
          },
          %{
            amount: 500.0,
            type: "credit"
          }
        ]
      }

      conn =
        post(conn, Routes.api_v1_transaction_path(conn, :create), transaction: transaction_attrs)

      assert %{
               "id" => id
             } = json_response(conn, 201)["data"]

      Enum.each(
        json_response(conn, 201)["data"]["amounts"],
        fn amount ->
          assert %{"id" => id} = amount
        end
      )
    end
  end
end
