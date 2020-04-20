defmodule Unplug.Predicates.EnvVarNotIn do
  @moduledoc """
  Given an environment variable, execute the plug if the environment
  variable value is not in the provided list of values.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.EnvVarNotIn, {"ENABLE_DEBUG", ["true", "1"]}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.EnvVarIn.call(conn, opts)
  end
end
