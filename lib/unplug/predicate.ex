defmodule Unplug.Predicate do
  @moduledoc """
  This behaviour defines the structure of a module that can be used
  as an Unplug filter.
  """

  @doc """
  The `eval/1` function
  """
  @callback call(conn :: Plug.Conn.t(), opts :: any()) :: boolean()
end
