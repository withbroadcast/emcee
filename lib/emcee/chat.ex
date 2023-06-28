defmodule Emcee.Chat do
  alias Emcee.Prompt

  @type message :: %{
    required(:role) => String.t(),
    required(:content) => String.t() | Prompt.t(),
    optional(:name) => String.t()
  }
end
