defmodule Unplug.Predicates.EnvVarIn do
  @moduledoc """
  Given an environment variable, execute the plug if the configured value
  matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.EnvVarIn, {"ENABLE_DEBUG", ["true", "1"]}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, {env_var, expected_values}) when is_list(expected_values) do
    System.get_env(env_var) in expected_values
  end
end
