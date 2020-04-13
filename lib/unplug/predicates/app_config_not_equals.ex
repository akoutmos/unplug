defmodule Unplug.Predicates.AppConfigNotEquals do
  @moduledoc """
  Given an application and a key, do not execute the plug if the configured
  value matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.AppConfigNotEquals, {:my_app, :some_config, :disabled}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.AppConfigEquals.call(conn, opts)
  end
end
