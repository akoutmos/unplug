defmodule Unplug.Predicates.EnvVarNotEqualsTest do
  use ExUnit.Case, async: false
  use Plug.Test

  test "should return false if the expected value matches the environment variable" do
    System.put_env("UNPLUG_ENV_VAR", "some_config_string")
    conn = conn(:get, "/")

    refute Unplug.Predicates.EnvVarNotEquals.call(conn, {"UNPLUG_ENV_VAR", "some_config_string"})
  end

  test "should return true if the expected value does not match the environment variable" do
    System.put_env("UNPLUG_ENV_VAR", "some_config_string")
    conn = conn(:get, "/")

    assert Unplug.Predicates.EnvVarNotEquals.call(conn, {"UNPLUG_ENV_VAR", "invalid"})
  end
end
