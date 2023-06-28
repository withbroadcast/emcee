defmodule Emcee.Chat.PromptTest do
  use ExUnit.Case, async: true
  alias Emcee.Prompt
  alias Emcee.Chat.Prompt, as: ChatPrompt

  describe "build_system_message/2" do
    test "builds a system message" do
      template = "You are an expert on <%= thing %>"
      msg = ChatPrompt.build_system_message(template)

      assert msg.role == :system
      assert msg.content == Prompt.new(template)
    end

    test "builds a system message with a name" do
      template = "You are an expert on <%= thing %>"
      msg = ChatPrompt.build_system_message(template, "some-name")

      assert msg.role == :system
      assert msg.content == Prompt.new(template)
      assert msg.name == "some-name"
    end
  end

  describe "build_assistant_message/2" do
    test "builds an assistant message" do
      template = "You are an expert on <%= thing %>"
      msg = ChatPrompt.build_assistant_message(template)

      assert msg.role == :assistant
      assert msg.content == Prompt.new(template)
    end

    test "builds a system message with a name" do
      template = "You are an expert on <%= thing %>"
      msg = ChatPrompt.build_assistant_message(template, "some-name")

      assert msg.role == :assistant
      assert msg.content == Prompt.new(template)
      assert msg.name == "some-name"
    end
  end

  describe "build_user_message/1" do
    test "builds a user message" do
      template = "Knock knock!"
      msg = ChatPrompt.build_user_message(template)

      assert msg.role == :user
      assert msg.content == Prompt.new(template)
    end
  end

  describe "eval/2" do
    test "evaluates a list of messages" do
      messages = [
        %{role: :system, content: Prompt.new("You are <%= name %>, a coding assistant.")},
        %{role: :assistant, content: Prompt.new("<%= text %>")},
        %{role: :user, content: Prompt.new("Can you help me write some code for <%= thing %>?")}
      ]
      inputs = [name: "Bob", text: "Some context", thing: "a chatbot"]

      expected = [
        %{role: :system, content: "You are Bob, a coding assistant."},
        %{role: :assistant, content: "Some context"},
        %{role: :user, content: "Can you help me write some code for a chatbot?"}
      ]

      assert ChatPrompt.eval(messages, inputs) == expected
    end
  end

  describe "required_inputs/1" do
    test "returns a list of required inputs" do
      messages = [
        %{role: :system, content: Prompt.new("You are <%= name %>, a coding assistant.")},
        %{role: :assistant, content: Prompt.new("<%= text %>")},
        %{role: :user, content: Prompt.new("Can you help me write some code for <%= thing %>?")}
      ]

      expected = [:name, :text, :thing]
      assert ChatPrompt.required_inputs(messages) == expected
    end
  end
end
