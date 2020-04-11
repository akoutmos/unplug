defmodule UnplugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest Unplug

  test "accepts anonymous functions for if/do/else" do
    opts =
      Unplug.init(
        if: fn c -> c.assigns[:thing] == "nice" end,
        do: fn c -> assign(c, :cool, "it's good") end,
        else: fn c -> assign(c, :no, "it's bad") end
      )

    conn =
      :get
      |> conn("/")
      |> Unplug.call(opts)

    assert conn.assigns == %{no: "it's bad"}

    conn =
      :get
      |> conn("/")
      |> assign(:thing, "nice")
      |> Unplug.call(opts)

    assert conn.assigns == %{cool: "it's good", thing: "nice"}
  end
end
