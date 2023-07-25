defmodule Emcee.Chat do
  alias Emcee.Prompt

  @type t :: %__MODULE__{
          template: String.t()
        }

  @type message :: %{
          required(:role) => String.t(),
          required(:content) => String.t() | Prompt.t(),
          optional(:name) => String.t()
        }

  @spec eval(t(), Keyword.t()) :: String.t()
  def eval(%__MODULE__{template: template}, inputs) do
    EEx.eval_string(template, inputs)
  end
end
