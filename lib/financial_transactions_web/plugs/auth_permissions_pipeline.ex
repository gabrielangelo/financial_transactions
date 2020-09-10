defmodule FinancialTransactionsWeb.PermissionsPlug do
  import  Plug.Conn
  alias Repo

  def init(opts), do: opts

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    authorize(conn, user, :is_staff)
  end

  def authorize(conn, %{is_staff: true} = _user, :is_staff) do
    conn
  end

  def authorize(conn, %{is_staff: false} = _user, :is_staff) do
    json_response = Phoenix.json_library().encode!(%{message: "Unathorized for this action"})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, json_response)
    |> halt
  end

end
