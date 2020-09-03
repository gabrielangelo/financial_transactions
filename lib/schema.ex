# Define a module to be used as base
defmodule FinancialTransactions.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :uuid, autogenerate: true}
      @foreign_key_type :uuid
    end
  end
end
