defmodule Unplug.Predicates.AppConfigNotEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, opts) do
    not Unplug.Predicates.AppConfigEquals.call(conn, opts)
  end
end
