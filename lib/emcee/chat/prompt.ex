defmodule Emcee.Chat.Prompt do
  alias Emcee.Prompt

  @roles ~w(system user assistant)a

  def build_message(role, text, name \\ nil)

  def build_message(role, text, nil) when role in @roles do
    %{role: role, content: Prompt.new(text)}
  end

  def build_message(role, text, name) when role in @roles do
    %{role: role, name: name, content: Prompt.new(text)}
  end

  def build_system_message(text, name \\ nil) do
    build_message(:system, text, name)
  end

  def build_assistant_message(text, name \\ nil) do
    build_message(:assistant, text, name)
  end

  def build_user_message(text) do
    build_message(:user, text)
  end

  def eval(messages, inputs) do
    Enum.map(messages, fn msg ->
      content = Prompt.eval(msg.content, inputs)
      Map.put(msg, :content, content)
    end)
  end

  def required_inputs(messages) do
    messages
    |> Enum.flat_map(fn msg -> Prompt.required_inputs(msg.content) end)
    |> Enum.uniq()
  end
end
