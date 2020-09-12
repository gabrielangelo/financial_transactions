defmodule FinancialTransactions.Accounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "transactions" do
    field :description, :string
    field :email_notification_status, :integer, default: 0
    field :is_external, :boolean
    field :status, :integer, default: 0
    field :type, :string
    field :value, :decimal
    field :emit_at, :date, default: Date.utc_today()
    # associations fields
    has_many :amounts, FinancialTransactions.Accounts.Amount

    belongs_to :from_account, FinancialTransactions.Accounts.Account
    belongs_to :to_account, FinancialTransactions.Accounts.Account

    timestamps()
  end

  @fields [
    :description,
    :email_notification_status,
    :is_external,
    :status,
    :value,
    :type,
    :emit_at
  ]
  @transaction_types ["withdraw", "transfer"]
  @assoc_ids [:from_account_id, :to_account_id]
  @required_fields [:description, :amounts, :value, :from_account_id, :type]

  @doc false
  def changeset(%__MODULE__{} = transaction, attrs \\ %{}) do
    transaction
    |> cast(attrs, @fields ++ @assoc_ids)
    |> validate_required(@required_fields)
    |> validate_inclusion(:type, @transaction_types)
    |> foreign_key_constraint(:from_account_id)
    |> foreign_key_constraint(:to_account_id)
    |> cast_assoc(:amounts, with: &FinancialTransactions.Accounts.Amount.changeset/2)
    |> validate_is_external_case(transaction)
    |> check_transaction_amounts(transaction)
    |> put_proper_accounts_to_amounts
  end

  defp get_field_by_transaction_type(changeset, transaction_type)
       when transaction_type == "debit" do
    get_field(changeset, :from_account_id)
  end

  defp get_field_by_transaction_type(changeset, transaction_type)
       when transaction_type == "credit" do
    get_field(changeset, :to_account_id)
  end

  defp assoc_amounts_to_proper_accounts(changeset, amount) do
    acc_value = get_field_by_transaction_type(changeset, Map.get(amount, :type))
    change(amount, %{account_id: acc_value})
  end

  defp put_proper_accounts_to_amounts(changeset) do
    assoc_amounts_with_accounts =
      get_field(changeset, :amounts)
      |> Enum.map(fn amount -> assoc_amounts_to_proper_accounts(changeset, amount) end)

    change(changeset, %{amounts: assoc_amounts_with_accounts})
  end

  defp validate_is_external_case(
         changeset,
         transaction
       ) do
    is_external = transaction.is_external

    cond do
      is_external == true &&
          get_field(changeset, :to_account_id) != nil ->
        add_error(changeset, :is_external, "external transaction cannot have to_account_id field")

      is_external == true &&
        get_field(changeset, :to_account_id) == nil and
          get_field(changeset, :type) == "withdraw" ->
        add_error(changeset, :type, "external transaction cannot be withdraw")

      is_external == true &&
        has_amounts?(changeset) &&
          "credit" in Enum.map(get_field(changeset, :amounts), & &1.type) ->
        add_error(changeset, :amounts, "external transaction cannot have credit amounts")

      true ->
        changeset
    end
  end

  defp has_amounts?(changeset) do
    !Enum.empty?(get_field(changeset, :amounts))
  end

  defp check_transaction_amounts(
         %Ecto.Changeset{changes: %{amounts: [_head | _tail]}} = changeset,
         %__MODULE__{type: "withdraw"} = transaction
       ) do
    amounts = get_field(changeset, :amounts)
    transaction_value = transaction.value

    if "credit" in Enum.map(amounts, & &1.type) do
      add_error(changeset, :amounts, "withdraw operation can't have credit amounts")
    else
      amount_values = Enum.map(amounts, & &1.amount)

      debit_sum =
        Enum.reduce(
          amount_values,
          Decimal.from_float(0.0),
          fn amount, acc -> Decimal.add(amount, acc) end
        )

      if Decimal.compare(debit_sum, transaction_value) == Decimal.new(0) do
        changeset
      else
        add_error(
          changeset,
          :amounts,
          "transaction value and amount(debit) values must be equals"
        )
      end
    end
  end

  defp check_transaction_amounts(
         %Ecto.Changeset{changes: %{amounts: [_head | _tails]}} = changeset,
         %__MODULE__{type: "transfer", is_external: false} = transaction
       ) do
    amounts =
      get_field(changeset, :amounts)
      |> Enum.group_by(& &1.type)

    reduce_initial_value = Decimal.from_float(0.0)

    credit_sum =
      Enum.reduce(amounts["credit"], reduce_initial_value, fn i, acc ->
        Decimal.add(i.amount, acc)
      end)

    debit_sum =
      Enum.reduce(amounts["debit"], reduce_initial_value, fn i, acc ->
        Decimal.add(i.amount, acc)
      end)

    transaction_value = transaction.value

    if transaction_value != 0 do
      add_error(changeset, :value, "transaction hasn't a value")
    end

    if Decimal.compare(credit_sum, debit_sum) == Decimal.new(0) &&
         Decimal.compare(debit_sum, transaction_value) == Decimal.new(0) do
      changeset
    else
      add_error(
        changeset,
        :amounts,
        "transaction value and amount values (credit and debit) must be equals"
      )
    end
  end

  defp check_transaction_amounts(
         %Ecto.Changeset{changes: %{amounts: [_head | _tails]}} = changeset,
         %__MODULE__{type: "transfer", is_external: true} = transaction
       ) do
    amounts =
      get_field(changeset, :amounts)
      |> Enum.group_by(& &1.type)

    debit_sum =
      Enum.reduce(
        amounts["debit"],
        Decimal.from_float(0.0),
        fn i, acc ->
          Decimal.add(i.amount, acc)
        end
      )

    transaction_value = transaction.value

    if Decimal.compare(debit_sum, transaction_value) == Decimal.new(0) do
      changeset
    else
      add_error(changeset, :amounts, "transaction value and amount(debit) values must be equals")
    end
  end

  defp check_transaction_amounts(
         %Ecto.Changeset{} = changeset,
         %__MODULE__{} = _transaction
       ) do
    changeset
  end
end
