defmodule Unplug.Predicates.AppConfigNotInTest do
  use ExUnit.Case, async: false
  use Plug.Test

  test "should return true if the application config key is NOT in the list" do
    Application.put_env(:unplug, :app_config_test, "some_config_string")
    Application.put_env(:unplug, :app_config_test_two, "some_other_config_string")
    conn = conn(:get, "/")

    refute Unplug.Predicates.AppConfigNotIn.call(
             conn,
             {:unplug, :app_config_test, ["some_config_string", "some_other_string"]}
           )

    refute Unplug.Predicates.AppConfigNotIn.call(
             conn,
             {:unplug, :app_config_test_two, ["some_config_string", "some_other_config_string"]}
           )
  end

  test "should return false if the application config key is in the list" do
    Application.put_env(:unplug, :app_config_test, "some_config_string")
    conn = conn(:get, "/")

    assert Unplug.Predicates.AppConfigNotIn.call(conn, {:unplug, :app_config_test, ["invalid"]})
  end
end
