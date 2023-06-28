defmodule Emcee.UtilsTest do
  use ExUnit.Case, async: true

  describe "model_token_limit/1" do
    test "returns the default token limit for unknown models" do
      assert Emcee.Utils.model_token_limit("unknown") == 2048
    end

    test "returns the correct token limit for gpt-4" do
      assert Emcee.Utils.model_token_limit("gpt-4") == 8192
    end

    test "returns the correct token limit for text-davinci-003" do
      assert Emcee.Utils.model_token_limit("text-davinci-003") == 4096
    end

    test "returns the correct token limit for gpt-3.5-turbo" do
      assert Emcee.Utils.model_token_limit("gpt-3.5-turbo") == 4096
    end

    test "returns the correct token limit for text-davinci-002" do
      assert Emcee.Utils.model_token_limit("text-davinci-002") == 4096
    end

    test "returns the correct token limit for code-davinci-002" do
      assert Emcee.Utils.model_token_limit("code-davinci-002") == 8000
    end
  end
end
