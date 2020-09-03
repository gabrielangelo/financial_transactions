defmodule FinancialTransactions.Reports do

  def extract_report(attrs \\ %{}) do
    FinancialTransactions.Tasks.ExtractReport.run(
      attrs["account_id"],
      attrs["start_date_range"],
      attrs["end_date_range"]
    )
  end
end
