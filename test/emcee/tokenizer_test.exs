defmodule Emcee.TokenizerTest do
  use ExUnit.Case, async: true

  describe "count_tokens/2" do
    test "raises an error for unsupported chat models" do
      messages = [
        %{role: "system", content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English."},
        %{role: "system", name: "example_user", content: "New synergies will help drive top-line growth."},
        %{role: "system", name: "example_assistant", content: "Things working well together will increase revenue."},
        %{role: "system", name: "example_user", content: "Let's circle back when we have more bandwidth to touch base on opportunities for increased leverage."},
        %{role: "system", name: "example_assistant", content: "Let's talk later when we're less busy about how to do better."},
        %{role: "user", content: "This late pivot means we don't have time to boil the ocean for the client deliverable."},
      ]

      assert_raise RuntimeError, "Model \"text-davinci-003\" is not a supported chat model", fn ->
        Emcee.Tokenizer.count_tokens(messages, "text-davinci-003")
      end
    end

    test "returns the correct token count for gpt-3.5-turbo" do
      messages = [
        %{role: "system", content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English."},
        %{role: "system", name: "example_user", content: "New synergies will help drive top-line growth."},
        %{role: "system", name: "example_assistant", content: "Things working well together will increase revenue."},
        %{role: "system", name: "example_user", content: "Let's circle back when we have more bandwidth to touch base on opportunities for increased leverage."},
        %{role: "system", name: "example_assistant", content: "Let's talk later when we're less busy about how to do better."},
        %{role: "user", content: "This late pivot means we don't have time to boil the ocean for the client deliverable."},
      ]

      assert Emcee.Tokenizer.count_tokens(messages, "gpt-3.5-turbo") == 127

      messages = [
        %{role: "system", content: "You are a helpful assistant."},
        %{role: "user", content: "Knock knock."},
        %{role: "assistant", content: "Who's there?"},
        %{role: "user", content: "Orange."},
      ]

      assert Emcee.Tokenizer.count_tokens(messages, "gpt-3.5-turbo") == 39
    end

    test "returns the correct token count for gpt-4" do
      messages = [
        %{role: "system", content: "You are a helpful, pattern-following assistant that translates corporate jargon into plain English."},
        %{role: "system", name: "example_user", content: "New synergies will help drive top-line growth."},
        %{role: "system", name: "example_assistant", content: "Things working well together will increase revenue."},
        %{role: "system", name: "example_user", content: "Let's circle back when we have more bandwidth to touch base on opportunities for increased leverage."},
        %{role: "system", name: "example_assistant", content: "Let's talk later when we're less busy about how to do better."},
        %{role: "user", content: "This late pivot means we don't have time to boil the ocean for the client deliverable."},
      ]

      assert Emcee.Tokenizer.count_tokens(messages, "gpt-4") == 129

      messages = [
        %{role: "system", content: "You are a helpful assistant."},
        %{role: "user", content: "Knock knock."},
        %{role: "assistant", content: "Who's there?"},
        %{role: "user", content: "Orange."},
      ]

      assert Emcee.Tokenizer.count_tokens(messages, "gpt-4") == 35
    end
  end
end
