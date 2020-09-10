defmodule FinancialTransactionsWeb.AccountControllerTest do
  use FinancialTransactionsWeb.ConnCase

  import FinancialTransactions.TestHelpers


  setup %{conn: conn} do
    {:ok, data} = build_authenticate_conns(conn)
    %{
      non_staff_user: non_staff_user
    } = data

    valid_account_attrs = %{
      name: "test account",
      user_id: non_staff_user.id
    }
    invalid_account_attrs = %{
      name: "test account"
    }

    data = Map.merge(data,
      %{valid_account_attrs: valid_account_attrs, invalid_account_attrs: invalid_account_attrs}
    )
    {:ok, data}
  end

  describe "index account" do

    test "lists all accounts", %{valid_account_attrs: valid_account_attrs, staff_conn: conn} do
      account = account_fixture(valid_account_attrs)
      conn = get(conn, Routes.account_path(conn, :index))
      accounts = json_response(conn, 200)["data"]
      assert Enum.map(accounts, &(&1["id"]))== [account.id]
    end
  end

  describe "show account" do
    test "renders account when data is valid",  %{valid_account_attrs: valid_account_attrs, staff_conn: conn} do
      account = account_fixture(valid_account_attrs)
      account_id = account.id
      conn = get(conn, Routes.account_path(conn, :show, account_id))
      assert %{"id" => account_id} = json_response(conn, 200)["data"]
    end
  end

  describe "create account" do
    test "create account with valid attrs", %{valid_account_attrs: valid_account_attrs, staff_conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: valid_account_attrs)
      assert %{
        "id" => id,
        "name" => name,
        "user_id" => user_id
      } = json_response(conn, 201)["data"]

    end
    test "renders errors when data is invalid", %{invalid_account_attrs: invalid_account_attrs, staff_conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: invalid_account_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "update account" do
    test "renders account when data is valid", %{valid_account_attrs: valid_account_attrs, staff_conn: conn} do
      account = account_fixture(valid_account_attrs)
      conn = put(conn, Routes.account_path(conn, :update, account), account: %{name: "Ups account"})
      account_id = account.id
      assert %{"id" => ^account_id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_path(conn, :show, account_id))

      assert %{
              "id" => id,
              "name" => "Ups account"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete account" do
    test "deletes chosen account", %{staff_conn: conn, valid_account_attrs: valid_account_attrs} do
      account = account_fixture(valid_account_attrs)
      conn = delete(conn, Routes.account_path(conn, :delete, account))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_path(conn, :show, account))
      end
    end
  end

end
