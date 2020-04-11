defmodule Unplug.Predicates.RequestHeaderEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, {header, expected_value}) do
    expected_value in Plug.Conn.get_req_header(conn, header)
  end
end
