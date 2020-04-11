defmodule Unplug.Predicates.EnvVarNotEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.EnvVarEquals.call(conn, opts)
  end
end
