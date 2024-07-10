defmodule Unplug.Compose.AllTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "should return true if all predicates return true" do
    conn =
      :get
      |> conn("/some_path")
      |> put_req_header("x-my-custom-header", "some_config_string")

    assert Unplug.Compose.All.call(conn, [
             Unplug.TestPredicates.AlwaysTrue,
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_path"}
           ])
  end

  test "should return false if any of the predicates return false" do
    conn =
      :get
      |> conn("/some_path")
      |> put_req_header("x-my-custom-header", "some_config_string")

    refute Unplug.Compose.All.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_other_path"}
           ])

    refute Unplug.Compose.All.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_other_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_path"}
           ])

    refute Unplug.Compose.All.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_other_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_other_path"}
           ])
  end
end
