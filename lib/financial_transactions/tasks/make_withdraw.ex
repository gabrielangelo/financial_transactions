defmodule FinancialTransactions.Tasks.MakeWithdraw do
  alias FinancialTransactions.Common, as: Common
  alias FinancialTransactions.Tasks.Managers, as: Manager

  def run(transaction, amount_attrs) do
    with transaction <- Common.load_assoc_accounts(transaction),
         from_account <- transaction.from_account,
         true <- Common.has_credit?(from_account.current_balance, transaction.value) do
      Manager.withdraw(
        transaction,
        amount_attrs,
        from_account
      )
    else
      false -> {:error, :invalid_balance}
    end
  end
end
