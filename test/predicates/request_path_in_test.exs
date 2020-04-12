defmodule Unplug.Predicates.RequestPathInTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "should return true if the expected value is in the request path list" do
    conn = conn(:get, "/healthcheck")

    assert Unplug.Predicates.RequestPathIn.call(conn, ["/metrics", "/healthcheck"])
  end

  test "should return false if the expected value is not in the request path list" do
    conn = conn(:get, "/users")

    refute Unplug.Predicates.RequestPathIn.call(conn, ["/metrics", "/healthcheck"])
  end

  test "should return true if the expected value is in the request path regex list" do
    conn = conn(:get, "/healthcheck")

    assert Unplug.Predicates.RequestPathIn.call(conn, ["/some_other_path", ~r/metrics/, ~r/healthcheck/])
  end

  test "should return false if the expected value does not match the request path regex" do
    conn = conn(:get, "/users")

    refute Unplug.Predicates.RequestPathIn.call(conn, ["/some_other_path", ~r/metrics/, ~r/healthcheck/])
  end
end
