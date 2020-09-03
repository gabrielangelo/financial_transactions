defmodule FinancialTransactionsWeb.Guardian do
  @moduledoc """
  JWT Authentication
  """
  use Guardian, otp_app: :financial_transactions

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = FinancialTransactions.Users.get_user!(id)
    {:ok, resource}
  end
end
