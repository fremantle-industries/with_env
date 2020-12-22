defmodule WithEnvTest do
  use ExUnit.Case
  use WithEnv
  doctest WithEnv

  test "can put values into the env" do
    assert Application.get_env(:hello, :saying) == nil

    with_env put: [hello: [saying: "galaxy"]] do
      assert Application.get_env(:hello, :saying) == "galaxy"
    end

    assert Application.get_env(:hello, :saying) == nil
  end

  test "can delete values from the env" do
    Application.put_env(:hello, :saying, "world")

    with_env delete: [hello: [:saying]] do
      assert Application.get_env(:hello, :saying) == nil
    end

    assert Application.get_env(:hello, :saying) == "world"
    assert Application.delete_env(:hello, :saying) == :ok
  end
end
