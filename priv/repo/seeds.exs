# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FinancialTransactions.Repo.insert!(%FinancialTransactions.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FinancialTransactions.Companies.Company
alias FinancialTransactions.Users.User
alias FinancialTransactions.Repo


company_attrs = %{
  name: "stone",
  accounts: [
    %{name: "stone account", current_balance: Decimal.new(1_000_000_000_000_000_000_000)}
  ]
}

%Company{}
|> Company.changeset(company_attrs)
|> Repo.insert()

staff_user = %{
  first_name: "Jack",
  last_name: "London",
  password: "123456Gg",
  is_staff: true,
  email: "staff@gmail.com"
}

%User{}
|> User.changeset(staff_user)
|> Repo.insert()
