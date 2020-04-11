defmodule Unplug.Predicates.RequestPathNotIn do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.RequestPathIn.call(conn, opts)
  end
end
