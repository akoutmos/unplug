defmodule Unplug.Predicates.RequestPathNotEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.RequestPathEquals.call(conn, opts)
  end
end
