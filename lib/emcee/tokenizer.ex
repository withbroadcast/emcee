defmodule Emcee.Tokenizer do
  @moduledoc """
  Tokenizers utility functions powered by TikToken.
  """

  @default_model "text-davinci-003"

  @chat_models ~w(
    gpt-4
    gpt-3.5-turbo
  )

  defp default_encoding(model) when model in @chat_models, do: Tiktoken.CL100K

  defp default_encoding(_), do: Tiktoken.P50K

  @doc """
  Convert the given input into a list of tokens.

  Currently implemented for strings only.
  """
  def tokenize(text, model \\ @default_model) when is_binary(text) do
    encoding = Tiktoken.encoding_for_model(model) || default_encoding(model)
    encoding.encode_with_special_tokens(text)
  end

  def tokenize!(text, model \\ @default_model) when is_binary(text) do
    {:ok, tokens} = tokenize(text, model)
    tokens
  end

  @tokens_per_reply 3

  @doc """
  Count the number of tokens in the given input.
  """
  def count_tokens(text_or_messages, model \\ @default_model)

  def count_tokens(messages, model) when is_list(messages) do
    if model not in @chat_models do
      raise RuntimeError, "Model #{inspect(model)} is not a supported chat model"
    end

    count_chat_tokens(messages, model)
  end

  def count_tokens(text, model) when is_binary(text) do
    text
    |> tokenize!(model)
    |> length()
  end

  @tokens_per_name %{
    "gpt-3.5-turbo" => -1,
    "gpt-3.5-turbo-0301" => -1,
    "gpt-4" => 1,
    "gpt-4-0314" => 1
  }

  def tokens_per_name(model) do
    Map.get(@tokens_per_name, model, 0)
  end

  @tokens_per_message %{
    "gpt-3.5-turbo" => 4,
    "gpt-3.5-turbo-0301" => 4,
    "gpt-4" => 3,
    "gpt-4-0314" => 3
  }

  defp tokens_per_message(model), do: Map.get(@tokens_per_message, model)

  defp count_chat_tokens(messages, model) do
    Enum.reduce(messages, @tokens_per_reply, fn msg, sum -> sum + count_message_tokens(msg, model) end)
  end

  defp count_message_tokens(message, model) do
    tokens_per_message(model) + Enum.reduce(message, 0, fn {k, v}, sum ->
      count_tokens(v, model) + tokens_for_key(k, model) + sum
    end)
  end

  defp tokens_for_key(:name, model), do: Map.get(@tokens_per_name, model, 1)
  defp tokens_for_key(_key, _model), do: 0
end
