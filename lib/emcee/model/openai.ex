defmodule Emcee.Model.Openai do
  alias Emcee.{Model, Prompt, Chat}

  @behaviour Model

  @default_params %{
    model: "text-davinci-003",
    temperature: 0.7,
    max_tokens: 250
  }

  @impl Model
  def new(params \\ %{}, _opts \\ []) do
    model_params = build_params(params)
    %Model{params: model_params}
  end

  defp build_params(params) do
    Map.merge(@default_params, params)
  end

  @impl Model
  def generate(model, inputs, opts \\ []) do
    case model.prompt do
      %Prompt{} ->
        generate_completion(model, inputs, opts)

      messages when is_list(messages) ->
        generate_chat(model, inputs, opts)

      _ ->
        raise ArgumentError, message: "Unexpected prompt: #{model.prompt}"
    end
  end

  def generate_completion(model, inputs, opts) do
    prompt = Prompt.eval(model.prompt, inputs)
    params = Map.put(model.params, :prompt, prompt)

    opts
    |> OpenAI.Client.new()
    |> OpenAI.Completions.create(params, opts)
    |> handle_response()
  end

  def generate_chat(model, inputs, opts) do
    messages = Chat.eval(model.prompt, inputs)
    params = Map.put(model.params, :messages, messages)

    opts
    |> OpenAI.Client.new()
    |> OpenAI.Chat.create_completion(params, opts)
    |> handle_response()
  end

  @impl Model
  def put_prompt(model, prompt) do
    %Model{model | prompt: prompt}
  end

  defp handle_response({:ok, stream} = resp) when is_function(stream),
    do: resp

  defp handle_response({:ok, %{"choices" => [%{"text" => text}]}}), do: {:ok, text}

  defp handle_response({:error, _reason} = err), do: err
end
