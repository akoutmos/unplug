defmodule Unplug.Predicates.AppConfigNotIn do
  @moduledoc """
  Given an application and a key, execute the plug if the configured value
  is not in the provided list of values.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.AppConfigNotIn, {:my_app, :some_config, [:enabled, :enabled_again]}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.AppConfigIn.call(conn, opts)
  end
end
