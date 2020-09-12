defmodule FinancialTransactionsWeb.UserControllerTest do
  use FinancialTransactionsWeb.ConnCase

  import FinancialTransactions.TestHelpers

  setup %{conn: conn} do
    build_authenticate_conns(conn)
  end

  describe "create user" do
    test "renders user when data is valid", %{staff_conn: conn} do
      company_fixture()

      data = %{
        "user" => %{
          "email" => "gg@gmail.com",
          "first_name" => "John",
          "last_name" => "Doe",
          "password" => "123456Gg",
          "accounts" => [
            %{
              "name" => "account with user"
            }
          ]
        }
      }

      conn = post(conn, "/api/v1/users", data)

      assert %{
               #  "id" => id,
               "email" => "gg@gmail.com",
               "first_name" => "John",
               "last_name" => "Doe"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when some data is invalid", %{staff_conn: conn} do
      data = %{
        "user" => %{
          "email" => "whatever",
          "first_name" => "John",
          "last_name" => "Doe",
          "password" => "123456Gg",
          "accounts" => [
            %{
              "name" => "account with user"
            }
          ]
        }
      }

      conn = post(conn, "/api/v1/users", data)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "test is_staff role required to create user", %{non_staff_conn: conn} do
      conn = post(conn, "/api/v1/users", %{})
      assert json_response(conn, 401) == %{"message" => "Unathorized for this action"}
    end
  end

  describe "show" do
    test "renders user", %{staff_conn: conn, staff_user: staff_user} do
      user_id = staff_user.id
      conn = get(conn, Routes.api_v1_user_path(conn, :show, user_id))
      assert %{"id" => user_id} = json_response(conn, 200)["data"]
    end
  end

  describe "index" do
    test "render users list", %{
      staff_conn: conn,
      staff_user: staff_user,
      non_staff_user: non_staff_user
    } do
      conn = get(conn, Routes.api_v1_user_path(conn, :index))
      users = json_response(conn, 200)["data"]
      assert Enum.map(users, & &1["id"]) == [staff_user.id, non_staff_user.id]
    end
  end
end
