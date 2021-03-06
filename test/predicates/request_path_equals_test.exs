defmodule Unplug.Predicates.RequestPathEqualsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "should return true if the expected value matches the request path" do
    conn = conn(:get, "/healthcheck")

    assert Unplug.Predicates.RequestPathEquals.call(conn, "/healthcheck")
  end

  test "should return false if the expected value does not match the request path" do
    conn = conn(:get, "/healthcheck")

    refute Unplug.Predicates.RequestPathEquals.call(conn, "/users")
  end

  test "should return true if the expected value matches the request path regex" do
    conn = conn(:get, "/healthcheck")

    assert Unplug.Predicates.RequestPathEquals.call(conn, ~r/healthcheck/)
  end

  test "should return false if the expected value does not match the request path regex" do
    conn = conn(:get, "/healthcheck")

    refute Unplug.Predicates.RequestPathEquals.call(conn, ~r/users/)
  end
end
