defmodule Unplug.Predicates.AppConfigEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, {app, key, expected_value}) do
    Application.get_env(app, key) == expected_value
  end
end
