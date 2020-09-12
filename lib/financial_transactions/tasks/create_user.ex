defmodule FinancialTransactions.Tasks.CreateUser do
  alias Ecto.Multi

  alias FinancialTransactions.Users.User
  alias FinancialTransactions.Companies.Company
  alias FinancialTransactions.Accounts.Account
  alias FinancialTransactions.Repo

  import Ecto.Query, only: [from: 2]

  @bank_name "stone"
  @initial_value 1000.0

  defp get_company() do
    query =
      from c in Company,
        join: account in Account,
        where: account.company_id == c.id and ilike(c.name, @bank_name),
        preload: [accounts: account]

    company = List.first(Repo.all(query))

    if company do
      company
    else
      %{accounts: [%{id: nil}]}
    end
  end

  defp process_transaction(company, account, user) do
    [company_account | _] = company.accounts

    %{
      description: "valor inicial da conta",
      type: "transfer",
      value: @initial_value,
      from_account_id: company_account.id,
      value: @initial_value,
      to_account_id: account.id,
      amounts: [
        %{amount: @initial_value, type: "debit"},
        %{amount: @initial_value, type: "credit"}
      ]
    }
    |> FinancialTransactions.Tasks.CreateTransaction.run(user, company)
  end

  defp make_transaction(user) do
    with company <- get_company(),
         [{:ok, stack}] <-
           Enum.map(user.accounts, fn account -> process_transaction(company, account, user) end) do
      {:ok, stack}
    else
      [{:error, %Ecto.Changeset{} = changeset}] ->
        {:error, changeset}

      nil ->
        {:error, :invalid_company}
    end
  end

  defp persist(user_transaction) do
    Ecto.Multi.new()
    |> Multi.insert(:user, user_transaction)
    |> Multi.run(:make_transaction, fn _repo, %{user: user} -> make_transaction(user) end)
    |> Repo.transaction()
  end

  def run(user_attrs) do
    user_changeset = %User{} |> User.changeset(user_attrs)

    if user_changeset.valid? do
      case persist(user_changeset) do
        {:ok, stack_changeset} -> {:ok, stack_changeset}
        {:error, changeset} -> {:error, changeset}
        {:error, _, changeset, _} -> {:error, changeset}
      end
    else
      {:error, user_changeset}
    end
  end
end
