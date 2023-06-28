defmodule Emcee.Utils do
  @model_token_limits %{
    "gpt-4" => 8192,
    "text-davinci-003" => 4096,
    "gpt-3.5-turbo" => 4096,
    "text-davinci-002" => 4096,
    "code-davinci-002" => 8000
  }

  @default_model_token_limit 2048

  def model_token_limit(model_name) do
    Map.get(@model_token_limits, model_name, @default_model_token_limit)
  end
end
