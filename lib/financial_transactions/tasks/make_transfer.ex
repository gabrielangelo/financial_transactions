defmodule FinancialTransactions.Tasks.MakeTransfer do
  alias FinancialTransactions.Tasks.Managers, as: Manager
  alias FinancialTransactions.Common, as: Common

  def run(transaction, amount_attrs) do
    with transaction <- Common.load_assoc_accounts(transaction),
         {from_account, to_account} <- {transaction.from_account, transaction.to_account},
         true <- Common.has_credit?(from_account.current_balance, transaction.value) do
      if transaction.is_external do
        Manager.external_transfer(
          transaction,
          amount_attrs,
          from_account
        )
      else
        Manager.internal_transfer(
          transaction,
          amount_attrs,
          from_account,
          to_account
        )
      end
    else
      false -> {:error, :invalid_balance}
    end
  end
end
