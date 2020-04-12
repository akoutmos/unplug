defmodule Unplug.Predicates.RequestPathNotInTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "should return false if the expected value is in the request path list" do
    conn = conn(:get, "/healthcheck")

    refute Unplug.Predicates.RequestPathNotIn.call(conn, ["/metrics", "/healthcheck"])
  end

  test "should return true if the expected value is not in the request path list" do
    conn = conn(:get, "/users")

    assert Unplug.Predicates.RequestPathNotIn.call(conn, ["/metrics", "/healthcheck"])
  end

  test "should return false if the expected value is in the request path regex list" do
    conn = conn(:get, "/healthcheck")

    refute Unplug.Predicates.RequestPathNotIn.call(conn, ["/some_other_path", ~r/metrics/, ~r/healthcheck/])
  end

  test "should return true if the expected value does not match the request path regex" do
    conn = conn(:get, "/users")

    assert Unplug.Predicates.RequestPathNotIn.call(conn, ["/some_other_path", ~r/metrics/, ~r/healthcheck/])
  end
end
