defmodule Unplug.Predicates.RequestHeaderNotEquals do
  @moduledoc """
  Given a request header, do not execute the plug if the request value matches
  the expected value.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestHeaderNotEquals, {"authorization", "super_secret"}},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.RequestHeaderEquals.call(conn, opts)
  end
end
