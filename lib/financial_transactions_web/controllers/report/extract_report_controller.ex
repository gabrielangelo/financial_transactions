defmodule FinancialTransactionsWeb.ExtractReportController do
  use FinancialTransactionsWeb, :controller
  alias FinancialTransactions.Reports

  action_fallback FinancialTransactionsWeb.FallbackController

  def index(conn, %{
    "account_id" => _,
    "start_date_range" => _,
    "end_date_range" => _
  } = attrs) do
    {:ok, data} = Reports.extract_report(attrs)
    render(conn, "show_extract_report.json", data)
  end

end
