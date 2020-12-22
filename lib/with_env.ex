defmodule WithEnv do
  defmacro __using__(_) do
    quote do
      import WithEnv

      test "ensure WithEnv is synchronous", context do
        refute context.async, """
        WithEnv cannot be used in async tests.
        To make this test case synchronous, modify your use of
        ExUnit.Case like so:
            use ExUnit.Case, async: false
        """
      end
    end
  end

  @type opts :: {:put, list} | {:delete, list}

  @spec with_env([opts], do: term) :: no_return
  defmacro with_env(actions, do: block) do
    quote do
      put_actions = unquote(actions) |> Keyword.get(:put, [])
      delete_actions = unquote(actions) |> Keyword.get(:delete, [])
      apps = (Keyword.keys(put_actions) ++ Keyword.keys(delete_actions)) |> Enum.uniq()

      previous_app_envs =
        apps
        |> Enum.reduce(
          [],
          fn app, acc ->
            Keyword.put(acc, app, Application.get_all_env(app))
          end
        )

      put_actions
      |> Enum.each(fn {app, attributes} ->
        attributes
        |> Enum.each(fn {k, v} ->
          Application.put_env(app, k, v)
        end)
      end)

      delete_actions
      |> Enum.each(fn {app, attribute_names} ->
        attribute_names
        |> Enum.each(fn k ->
          Application.delete_env(app, k)
        end)
      end)

      unquote(block)

      apps
      |> Enum.each(fn app ->
        app
        |> Application.get_all_env()
        |> Enum.each(fn {k, v} ->
          Application.delete_env(app, k)
        end)
      end)

      previous_app_envs
      |> Enum.each(fn {app, attributes} ->
        attributes
        |> Enum.each(fn {k, v} ->
          Application.put_env(app, k, v)
        end)
      end)
    end
  end
end
