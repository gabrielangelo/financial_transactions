defmodule FinancialTransactions.Tasks.CreateUser do
  alias Ecto.Multi

  alias FinancialTransactions.Users.User
  alias FinancialTransactions.Companies.Company
  alias FinancialTransactions.Accounts.Account
  alias FinancialTransactions.Repo

  import Ecto.Query, only: [from: 2]

  @bank_name "stone"
  @initial_value 1000.0

  defp get_bank_account_company_id() do
    query = (
      from a in Account, join: c in Company, where: a.company_id == c.id
      and ilike(c.name, @bank_name), select: a.id
    )
    List.first(Repo.all(query))
  end

  defp process_transaction(bank_account_id, account) do
    %{
      description: "valor inicial da conta",
      type: "transfer",
      value: @initial_value,
      from_account_id: bank_account_id,
      value: @initial_value,
      to_account_id: account.id,
      amounts: [
          %{amount: @initial_value, type: "debit"},
          %{amount: @initial_value, type: "credit"},
      ],
    }
    |> FinancialTransactions.Tasks.CreateTransaction.run()
  end

  def run(user_attrs) do
    case Ecto.Multi.new()
    |> Multi.insert(:user, %User{} |> User.changeset(user_attrs))
    |> Multi.run(:make_transaction, fn _repo, %{user: user} ->
        bank_account_id = get_bank_account_company_id()
        case Enum.map(user.accounts, fn account ->
          process_transaction(bank_account_id, account)
        end) do
          [{:ok, stack}] -> {:ok, stack}
        end
      end
    )
    |> Repo.transaction do
      {:ok, stack} -> {:ok, stack.user}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
    end
  end

end
