defmodule FinancialTransactions.ExtractReportControllerTest do
  use FinancialTransactionsWeb.ConnCase

  import FinancialTransactions.TestHelpers
  alias FinancialTransactions.Transactions

  setup %{conn: conn} do
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

    user_one_account = List.first(user_one.accounts)
    user_two_account = List.first(user_two.accounts)

    out_transactions = [
      %{
        description: "Cigarette portfolio",
        type: "transfer",
        from_account_id: user_one_account.id,
        to_account_id: user_two_account.id,
        value: 100.0,
        amounts: [
          %{
            amount: 100.0,
            type: "debit"
          },
          %{
            amount: 100.0,
            type: "credit"
          }
        ]
      },
      %{
        description: "Withdraw to beer",
        type: "withdraw",
        from_account_id: user_one_account.id,
        value: 150.0,
        amounts: [
          %{
            amount: 150.0,
            type: "debit"
          }
        ]
      }
    ]

    in_transactions = [
      %{
        description: "Cigarette portfolio",
        type: "transfer",
        from_account_id: user_two_account.id,
        to_account_id: user_one_account.id,
        value: 600.0,
        amounts: [
          %{
            amount: 600.0,
            type: "debit"
          },
          %{
            amount: 600.0,
            type: "credit"
          }
        ]
      },
      %{
        description: "Cigarette portfolio",
        type: "transfer",
        from_account_id: user_two_account.id,
        to_account_id: user_one_account.id,
        value: 500.0,
        emit_at: Date.add(Date.utc_today(), -1),
        amounts: [
          %{
            amount: 500.0,
            type: "debit"
          },
          %{
            amount: 500.0,
            type: "credit"
          }
        ]
      }
    ]

    Enum.map(out_transactions, fn transaction ->
      Transactions.create_transaction(transaction, user_one)
    end)

    Enum.map(in_transactions, fn transaction ->
      Transactions.create_transaction(transaction, user_two)
    end)

    {:ok, data} = build_authenticate_conns(conn)

    data =
      Map.merge(data, %{user_one_account: user_one_account, user_two_account: user_two_account})

    {:ok, data}
  end

  describe "Reports" do
    test "test report controller", %{non_staff_conn: conn, user_one_account: user_one_account} do
      start_date_range = Date.to_iso8601(Date.add(Date.utc_today(), -1))
      end_date_range = Date.to_iso8601(Date.utc_today())
      account_id = user_one_account.id

      query_params = %{
        "account_id" => account_id,
        "start_date_range" => start_date_range,
        "end_date_range" => end_date_range
      }

      conn = get(conn, Routes.api_v1_extract_report_path(conn, :index, query_params))
      data = json_response(conn, 200)["data"]
      assert data["in"]["total"] == "R$1100.0"
      assert data["out"]["total"] == "R$250.0"
    end
  end
end
