defmodule Unplug.TestPlugs.AddDefaultAssign do
  import Plug.Conn

  @behaviour Plug

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(conn, _opts) do
    assign(conn, :some, "default_value")
  end
end
