defmodule Emcee.Sequence do
  @type opts ::
    binary()
    | tuple()
    | atom()
    | integer()
    | float()
    | [opts()]
    | %{optional(opts()) => opts()}

  @callback new(opts()) :: opts()
  @callback run(term(), opts()) :: {:ok, String.t()} | {:error, term()}

  def __using__(_opts) do
    quote do
    end
  end
end
