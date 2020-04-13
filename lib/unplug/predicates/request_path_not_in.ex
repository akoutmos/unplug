defmodule Unplug.Predicates.RequestPathNotIn do
  @moduledoc """
  Given a request path, do not execute the plug if the request value is
  in the the provided list of values.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestPathNotIn, ["/metrics", "/healthcheck"]},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    not Unplug.Predicates.RequestPathIn.call(conn, opts)
  end
end
