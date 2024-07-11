defmodule Unplug.Compose.AnyTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "should return true if any predicate return true" do
    conn =
      :get
      |> conn("/some_path")
      |> put_req_header("x-my-custom-header", "some_config_string")

    assert Unplug.Compose.Any.call(conn, [
             Unplug.TestPredicates.AlwaysTrue,
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_path"}
           ])

    assert Unplug.Compose.Any.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_other_config_string"}},
             Unplug.TestPredicates.AlwaysTrue,
             {Unplug.Predicates.RequestPathEquals, "/some_other_path"}
           ])

    assert Unplug.Compose.Any.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_other_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_path"}
           ])

    assert Unplug.Compose.Any.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_other_path"}
           ])
  end

  test "should return false if all predicates return false" do
    conn =
      :get
      |> conn("/some_path")
      |> put_req_header("x-my-custom-header", "some_config_string")

    refute Unplug.Compose.Any.call(conn, [
             {Unplug.Predicates.RequestHeaderEquals, {"x-my-custom-header", "some_other_config_string"}},
             {Unplug.Predicates.RequestPathEquals, "/some_other_path"}
           ])
  end
end
