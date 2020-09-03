defmodule FinancialTransactions.Tasks.ExtractReport do
  import Ecto.Query, only: [from: 2]
  alias FinancialTransactions.Accounts.Transaction
  alias FinancialTransactions.Repo

  def run(account_id, %Date{} = start_date_range, %Date{} = end_date_range) do
    process(account_id, start_date_range, end_date_range)
  end

  def run(account_id, start_date_range, end_date_range)
  when is_binary(start_date_range) and is_binary(end_date_range) do
    {{:ok, start_date_range}, {:ok,end_date_range}} = {Date.from_iso8601(start_date_range), Date.from_iso8601(end_date_range)}
    process(account_id, start_date_range, end_date_range)
  end

  defp process(account_id, start_date_range, end_date_range) do
    query_out = from(
     t in Transaction,
      where: (
        t.status == 1
         and t.emit_at >= ^start_date_range
         and t.emit_at <= ^end_date_range
         and t.from_account_id == ^account_id
      ),
      group_by: t.emit_at,
      select: %{emit_at: t.emit_at, total: sum(t.value)}
    )
    query_in = from(
     t in Transaction,
      where: (
        t.status == 1
        and t.emit_at >= ^start_date_range
        and t.emit_at <= ^end_date_range
        and t.to_account_id == ^account_id
      ),
      group_by: t.emit_at,
      select: %{emit_at: t.emit_at, total: sum(t.value)}
    )

    in_transactions = Repo.all(query_in)
    out_transactions = Repo.all(query_out)
    reduce_initial_value = Decimal.from_float(0.0)
    total_in = Enum.reduce(in_transactions, reduce_initial_value, fn(transaction, acc) ->
      Decimal.add(transaction.total, acc) end )
    total_out = Enum.reduce(out_transactions, reduce_initial_value, fn(transaction, acc) ->
      Decimal.add(transaction.total, acc) end )

    report_data = %{
      in: %{
        transactions: in_transactions,
        total: "R$#{total_in}"
      },
      out: %{
        transactions: out_transactions,
        total: "R$#{total_out}"
      }
    }
    {:ok, report_data}
  end
end
