defmodule Unplug.Predicates.AppConfigIn do
  @moduledoc """
  Given an application and a key, execute the plug if the configured value
  is in the provided list of values.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.AppConfigIn, {:my_app, :some_config, [:enabled, :enabled_again]}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, {app, key, expected_values}) do
    Application.get_env(app, key) in expected_values
  end
end
