defmodule Unplug.Predicates.AppConfigNotEqualsTest do
  use ExUnit.Case, async: false
  use Plug.Test

  test "should return false if the expected value matches the application config" do
    Application.put_env(:unplug, :app_config_test, "some_config_string")
    conn = conn(:get, "/")

    refute Unplug.Predicates.AppConfigNotEquals.call(conn, {:unplug, :app_config_test, "some_config_string"})
  end

  test "should return true if the expected value does not match the application config" do
    Application.put_env(:unplug, :app_config_test, "some_config_string")
    conn = conn(:get, "/")

    assert Unplug.Predicates.AppConfigNotEquals.call(conn, {:unplug, :app_config_test, "invalid"})
  end
end
