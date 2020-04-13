defmodule Unplug.Predicates.RequestPathNotEquals do
  @moduledoc """
  Given a request path, do not execute the plug if the request value
  matches the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestPathNotEquals, "/metrics"},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.RequestPathEquals.call(conn, opts)
  end
end
