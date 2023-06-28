defmodule Emcee.Prompt do
  @type t :: %__MODULE__{
    template: String.t()
  }

  @type template :: String.t()

  @type inputs :: Keyword.t()

  defstruct [:template]

  @doc """
  Creates a new prompt with the given template.

  ## Examples

      iex> Emcee.Prompt.new("Tell me a story about <%= noun %>")
      %Emcee.Prompt{template: "Tell me a story about <%= noun %>"}
  """
  @spec new(template()) :: t()
  def new(template), do: %__MODULE__{template: template}

  @doc """
  Updates the template of the prompt.

  ## Examples

      iex> prompt = Emcee.Prompt.new("Tell me a story about <%= noun %>")
      %Emcee.Prompt{template: "Tell me a story about <%= noun %>"}
      iex> prompt = Emcee.Prompt.put_template(prompt, "Tell me a story about <%= noun1 %> and <%= noun2 %>")
      %Emcee.Prompt{template: "Tell me a story about <%= noun1 %> and <%= noun2 %>"}
  """
  @spec put_template(t(), String.t()) :: t()
  def put_template(prompt, template) when is_binary(template) do
    %{prompt | template: template}
  end

  @doc """
  Evaluates the prompt with the given inputs.

  ## Examples

      iex> prompt = Emcee.Prompt.new("Tell me a story about <%= noun %>")
      %Emcee.Prompt{template: "Tell me a story about <%= noun %>"}
      iex> Emcee.Prompt.eval(prompt, [noun: "cats"])
      "Tell me a story about cats"
  """
  @spec eval(t(), Keyword.t()) :: String.t()
  def eval(%__MODULE__{template: template}, inputs) do
    EEx.eval_string(template, inputs)
  end

  @doc """
  Returns the list of required inputs.

  ## Examples

      iex> prompt = Emcee.Prompt.new("Tell me a story about <%= noun %> and <%= noun2 %>")
      %Emcee.Prompt{template: "Tell me a story about <%= noun %> and <%= noun2 %>"}
      iex> Emcee.Prompt.required_inputs(prompt)
      [:noun, :noun2]
  """
  def required_inputs(prompt) do
    prompt.template
    |> EEx.compile_string()
    |> extract_variables()
    |> Enum.reverse()
  end

  defp extract_variables(ast) do
    do_extract_variables(ast, [])
  end

  defp do_extract_variables({:__block__, _, elements}, acc) do
    Enum.reduce(elements, acc, fn element, acc ->
      do_extract_variables(element, acc)
    end)
  end

  defp do_extract_variables({:=, _, [_, {{:., _, [{:__aliases__, _, _}, :to_string]}, _, [variable_def]}]}, acc) do
    case variable_def do
      {var_atom, _, _} -> [var_atom | acc]
      _ -> acc
    end
  end

  defp do_extract_variables({_, _, elements}, acc) when is_list(elements) do
    Enum.reduce(elements, acc, fn element, acc ->
      do_extract_variables(element, acc)
    end)
  end

  defp do_extract_variables(_, acc) do
    acc
  end
end
