defmodule WithEnvTest do
  use ExUnit.Case
  doctest WithEnv

  test "greets the world" do
    assert WithEnv.hello() == :world
  end
end
