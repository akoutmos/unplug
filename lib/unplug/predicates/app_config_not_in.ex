defmodule Unplug.Predicates.AppConfigNotIn do
  @moduledoc """
  Given an application and a key, execute the plug if the configured value
  matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.AppConfigNotIn, {:my_app, :some_config, [:enabled, :enabled_again]}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, {app, key, expected_values}) when is_list(expected_values) do
    Application.get_env(app, key) not in expected_values
  end
end
