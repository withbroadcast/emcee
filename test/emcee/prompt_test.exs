defmodule Emcee.PromptTest do
  use ExUnit.Case, async: true
  alias Emcee.Prompt

  describe "new/1" do
    test "creates a new prompt with the given template" do
      prompt = Prompt.new("Tell me a story about <%= noun %>")
      assert prompt.template == "Tell me a story about <%= noun %>"
    end
  end

  describe "put_template/2" do
    test "updates the template of the prompt" do
      prompt =
        "Tell me a story about <%= noun %>"
        |> Prompt.new()
        |> Prompt.put_template("Tell me a story about <%= noun1 %> and <%= noun2 %>")
      assert prompt.template == "Tell me a story about <%= noun1 %> and <%= noun2 %>"
    end
  end

  describe "eval/2" do
    test "evaluates the prompt with the given inputs" do
      prompt = Prompt.new("Tell me a story about <%= noun %>")
      assert Prompt.eval(prompt, [noun: "cats"]) == "Tell me a story about cats"
    end
  end

  describe "required_inputs/1" do
    test "returns the list of required inputs" do
      prompt = Prompt.new("Tell me a story about <%= noun %> and <%= noun2 %>")
      assert Prompt.required_inputs(prompt) == [:noun, :noun2]
    end
  end
end
