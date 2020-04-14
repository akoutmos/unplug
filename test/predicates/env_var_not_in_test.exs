defmodule Unplug.Predicates.EnvVarNotInTest do
  use ExUnit.Case, async: false
  use Plug.Test

  test "should return false if the env var is in the list of acceptable keys" do
    System.put_env("UNPLUG_ENV_VAR", "some_config_string")
    conn = conn(:get, "/")

    refute Unplug.Predicates.EnvVarNotIn.call(
             conn,
             {"UNPLUG_ENV_VAR", ["some_config_string", "some_other_config_string"]}
           )
  end

  test "should return true if the env var is not in the list of acceptable keys" do
    System.put_env("UNPLUG_ENV_VAR", "some_config_string")
    conn = conn(:get, "/")

    assert Unplug.Predicates.EnvVarNotIn.call(conn, {"UNPLUG_ENV_VAR", ["invalid", "still_invalid"]})
  end
end
