defmodule Unplug.Predicates.RequestHeaderNotEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.RequestHeaderEquals.call(conn, opts)
  end
end
