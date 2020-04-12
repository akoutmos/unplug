defmodule Unplug.Predicates.RequestPathEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, %Regex{} = req_path) do
    Regex.match?(req_path, conn.request_path)
  end

  def call(conn, req_path) do
    String.equivalent?(req_path, conn.request_path)
  end
end
