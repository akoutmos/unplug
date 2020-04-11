defmodule Unplug.Predicates.RequestHeaderEquals do
  @moduledoc """
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, {header, expected_value}) do
    Plug.Conn.get_req_header(conn, header) == expected_value
  end
end
