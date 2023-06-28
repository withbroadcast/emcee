defmodule Emcee.Model do
  alias Emcee.{Chat, Prompt}

  @type t :: %__MODULE__{
    prompt: Prompt.t() | [Chat.message()] | nil,
    params: map(),
    extra: map(),
    errors: map()
  }

  defstruct [prompt: nil, params: %{}, extra: %{}, errors: %{}]

  @callback new(params :: map(), opts :: Keyword.t()) :: t()

  @callback generate(model :: t(), inputs :: Keyword.t(), opts :: Keyword.t()) :: {:ok, String.t()} | {:error, term()}

  @callback put_prompt(model :: t(), prompt :: Prompt.t() | [Chat.message()]) :: t()

  def put_param(model, key, value) do
    %{model | params: Map.put(model.params, key, value)}
  end
end
