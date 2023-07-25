defmodule Emcee.Chat do
  alias Emcee.Prompt

  @type message :: %{
          required(:role) => String.t(),
          required(:content) => String.t() | Prompt.t(),
          optional(:name) => String.t()
        }

  @spec eval(Prompt.t(), Keyword.t()) :: String.t()
  def eval(%Prompt{template: template}, inputs) do
    EEx.eval_string(template, inputs)
  end
end
