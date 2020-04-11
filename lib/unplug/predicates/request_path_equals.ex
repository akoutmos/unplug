defmodule Unplug.Predicates.RequestPathEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    String.equivalent?(opts, conn.request_path)
  end
end
