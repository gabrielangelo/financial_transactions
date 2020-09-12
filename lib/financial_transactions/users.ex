defmodule FinancialTransactions.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias FinancialTransactions.Repo

  alias FinancialTransactions.Users.User
  alias FinancialTransactions.Accounts.Account

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    company_query = from(a in Account, where: a.is_active == true, select: a.id)
    query = from(u in User, where: u.is_active == true, preload: [accounts: ^company_query])
    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get_by(User, id: id, is_active: true)
    |> Repo.preload(:accounts)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    case FinancialTransactions.Tasks.CreateUser.run(attrs) do
      {:ok, stack} ->
        transaction = stack.make_transaction

        user_data = %{
          user: stack.user,
          account: transaction.to_account_update
        }

        {:ok, user_data}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    user
    |> User.update_changeset(%{is_active: true})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
