defmodule Unplug.Predicates.EnvVarEquals do
  @moduledoc """
  Given an environment variable, execute the plug if the configured value
  matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.EnvVarEquals, {"ENABLE_DEBUG", "true"}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, {env_var, expected_value}) do
    System.get_env(env_var) == expected_value
  end
end
