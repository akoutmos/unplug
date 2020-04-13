defmodule Unplug.TestPredicates.AlwaysTrue do
  @behaviour Unplug.Predicate

  @impl true
  def call(_conn, _) do
    true
  end
end
