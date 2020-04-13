defmodule Unplug.Predicates.EnvVarNotEquals do
  @moduledoc """
  Given an environment variable, do not execute the plug if the configured
  value matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.EnvVarNotEquals, {"ENABLE_DEBUG", "false"}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.EnvVarEquals.call(conn, opts)
  end
end
