defmodule FinancialTransactions.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @regex_email_validator ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$/

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :is_active, :boolean, default: true
    field :is_staff, :boolean, default: false

    field :with_default_account, :boolean, virtual: true, default: false

    # virtual fields
    field :password, :string, virtual: true

    # associations
    has_many :accounts, FinancialTransactions.Accounts.Account

    timestamps()
  end

  @fields [:email, :first_name, :last_name, :password, :with_default_account, :is_staff]
  @required_fields [:email, :first_name, :last_name, :password]

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_required([:email])
    |> unique_email
    |> validate_password(:password)
    |> put_hash_password
    |> cast_assoc(:accounts, with: &FinancialTransactions.Accounts.Account.changeset/2)
    |> put_assoc_default_account
  end

  def update_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :is_staff, :is_active, :password])
    |> validate_password(:password)
    |> put_hash_password
  end

  defp unique_email(changeset) do
    changeset
    |> validate_format(
      :email,
      @regex_email_validator
    )
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
  end

  defp put_assoc_default_account(changeset) do
    accounts = get_field(changeset, :accounts)
    with_default_account = get_field(changeset, :with_default_account)
    if (
      (accounts == nil || Enum.empty?(accounts))
      && with_default_account
    ) do
      first_name = get_field(changeset, :first_name)
      last_name = get_field(changeset, :last_name)

      default_account = %{name: "#{first_name} - #{last_name}"}
      change(changeset, %{accounts: [default_account]})
    else
      changeset
    end
  end

  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp put_hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Bcrypt.hash_pwd_salt(password)})
  end

  defp put_hash_password(changeset) do
    changeset
  end

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}

end
