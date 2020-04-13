defmodule Unplug.Predicates.AppConfigEquals do
  @moduledoc """
  Given an application and a key, execute the plug if the configured value
  matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.AppConfigEquals, {:my_app, :some_config, :enabled}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, {app, key, expected_value}) do
    Application.get_env(app, key) == expected_value
  end
end
