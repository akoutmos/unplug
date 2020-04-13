defmodule Unplug.Predicates.RequestHeaderEquals do
  @moduledoc """
  Given a request header, execute the plug if the request value matches the
  expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestHeaderEquals, {"authorization", "super_secret"}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, {header, expected_value}) do
    expected_value in Plug.Conn.get_req_header(conn, header)
  end
end
