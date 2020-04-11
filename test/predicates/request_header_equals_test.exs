defmodule Unplug.Predicates.RequestHeaderEqualsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "should return true if the expected value matches the request HTTP header" do
    conn =
      :get
      |> conn("/")
      |> put_req_header("x-my-custom-header", "some_config_string")

    assert Unplug.Predicates.RequestHeaderEquals.call(conn, {"x-my-custom-header", "some_config_string"})
  end

  test "should return true if the expected value does not match the request HTTP header" do
    conn =
      :get
      |> conn("/")
      |> put_req_header("x-my-custom-header", "some_config_string")

    refute Unplug.Predicates.RequestHeaderEquals.call(conn, {"x-my-custom-header", "invalid"})
  end
end
