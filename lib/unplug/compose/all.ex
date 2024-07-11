defmodule Unplug.Compose.All do
  @moduledoc """
  Given a list of predicates, execute the plug if all of the predicates return
  true.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Compose.All, [
      {Unplug.Predicates.AppConfigEquals, {:my_app, :some_config, :enabled}},
      MyApp.CustomPredicate
    ]},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, predicates) do
    Enum.all?(predicates, fn
      {module, opts} -> module.call(conn, opts)
      module when is_atom(module) -> module.call(conn, [])
    end)
  end
end
