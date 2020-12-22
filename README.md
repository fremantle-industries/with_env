# WithEnv
[![Build Status](https://github.com/fremantle-industries/with_env/workflows/test/badge.svg?branch=master)](https://github.com/fremantle-industries/with_env/actions?query=workflow%3ATest)
[![hex.pm version](https://img.shields.io/hexpm/v/with_env.svg?style=flat)](https://hex.pm/packages/with_env)

Manage the Elixir application environment within a context

## Installation

Add the `with_env` package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:with_env, "~> 0.0.1"}]
end
```

## Usage

```elixir
defmodule HelloTest do
  use ExUnit.Case
  use WithEnv

  test "returns the application configured value" do
    with_env put: [hello: [saying: "galaxy"]] do
      assert Hello.saying() == "galaxy"
    end
  end

  test "returns 'world' by default" do
    with_env delete: [hello: [:saying]] do
      assert Hello.saying() == "world"
    end
  end
end
```
