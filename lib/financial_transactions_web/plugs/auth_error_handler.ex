defmodule FinancialTransactionsWeb.AuthErrorHandler do
  @moduledoc """
  Guardian error handler
  """

  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    json_response = Phoenix.json_library().encode!(%{message: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, json_response)
  end
end
