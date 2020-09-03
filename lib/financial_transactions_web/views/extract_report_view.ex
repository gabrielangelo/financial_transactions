defmodule FinancialTransactionsWeb.ExtractReportView do
  def render("show_extract_report.json", data) do
    %{
      data: %{
        in: data.in,
        out: data.out
      }
    }
  end
end
