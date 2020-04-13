defmodule Unplug.Predicates.RequestPathEquals do
  @moduledoc """
  Given a request path, execute the plug if the request value matches the
  expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestPathEquals, "/metrics"},
    do: MyApp.Plug
  ```
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
