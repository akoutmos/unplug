defmodule Unplug.Predicates.EnvVarEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, {env_var, expected_value}) do
    System.get_env(env_var) == expected_value
  end
end
