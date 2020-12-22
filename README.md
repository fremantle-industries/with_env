# WithEnv
[![Build Status](https://github.com/fremantle-industries/with_env/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/with_env/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/with_env.svg?style=flat)](https://hex.pm/packages/with_env)

Manage the Elixir application environment within a context

## Installation

Add the `with_env` package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:with_env, "~> 0.1", only: :test}]
end
```

## Usage

```elixir
defmodule HelloTest do
  use ExUnit.Case
  use WithEnv

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
```
