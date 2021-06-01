defmodule Edukator.AccountsFactory do
  @moduledoc """
  Factory for modules inside the `Accounts` context
  """

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Edukator.Accounts.User{
          name: "Camilo Hollanda",
          email: sequence(:email, &"email-#{&1}@example.com")
          # document: Brcpfcnpj.cpf_generate(true)
        }
      end
    end
  end
end
