defmodule Unplug.TestPlugs.AddAssign do
  import Plug.Conn

  @behaviour Plug

  @impl true
  def init({_key, _value} = opts) do
    opts
  end

  @impl true
  def call(conn, {key, value}) do
    assign(conn, key, value)
  end
end
