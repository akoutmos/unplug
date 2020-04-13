defmodule UnplugTest do
  use ExUnit.Case, async: false
  use Plug.Test

  alias Unplug.Predicates.{
    RequestHeaderEquals
  }

  alias Unplug.TestPlugs.{
    AddAssign,
    AddDefaultAssign
  }

  alias Unplug.TestPredicates.AlwaysTrue

  describe "Unplug" do
    test "should raise an error if an invalid init_mode is set" do
      Application.put_env(:unplug, :init_mode, :invalid)

      assert_raise(RuntimeError, fn ->
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: AddDefaultAssign
        )
      end)
    end
  end

  describe "Unplug running in init_mode :runtime" do
    setup do
      Application.put_env(:unplug, :init_mode, :runtime)
    end

    test "should reevaluate the init function" do
      # TODO
    end

    test "should execute the :do module when the :if predicate module yields true" do
      opts =
        Unplug.init(
          if: AlwaysTrue,
          do: AddDefaultAssign
        )

      conn =
        :get
        |> conn("/")
        |> assign(:cool, "old_thing")
        |> put_req_header("authorization", "super_secret")
        |> Unplug.call(opts)

      assert conn.assigns == %{some: "default_value", cool: "old_thing"}
    end

    test "should execute the :else tuple when the predicate yields true" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: {AddAssign, {:some, "thing"}},
          else: {AddAssign, {:other, "setting"}}
        )

      conn =
        :get
        |> conn("/")
        |> put_req_header("authorization", "invalid")
        |> Unplug.call(opts)

      assert conn.assigns == %{other: "setting"}
    end

    test "should execute the :do module when the :if predicate tuple yields true" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: AddDefaultAssign
        )

      conn =
        :get
        |> conn("/")
        |> assign(:cool, "old_thing")
        |> put_req_header("authorization", "super_secret")
        |> Unplug.call(opts)

      assert conn.assigns == %{some: "default_value", cool: "old_thing"}
    end

    test "should not execute the :do module when the :if predicate tuple yields false" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: AddDefaultAssign
        )

      conn =
        :get
        |> conn("/")
        |> assign(:cool, "old_thing")
        |> put_req_header("authorization", "invalid")
        |> Unplug.call(opts)

      assert conn.assigns == %{cool: "old_thing"}
    end
  end

  describe "Unplug running in init_mode :compile" do
    setup do
      Application.put_env(:unplug, :init_mode, :compile)
    end

    test "should not reevaluate the init function" do
      # TODO
    end

    test "should execute the :do module when the :if predicate tuple yields true" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: AddDefaultAssign
        )

      conn =
        :get
        |> conn("/")
        |> assign(:cool, "old_thing")
        |> put_req_header("authorization", "super_secret")
        |> Unplug.call(opts)

      assert conn.assigns == %{some: "default_value", cool: "old_thing"}
    end

    test "should return the non-mutated assigns when the :if predicate tuple yields false and there is no :else" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: {AddAssign, {:some, "thing"}}
        )

      conn =
        :get
        |> conn("/")
        |> assign(:cool, "old_thing")
        |> put_req_header("authorization", "invalid")
        |> Unplug.call(opts)

      assert conn.assigns == %{cool: "old_thing"}
    end

    test "should execute the :do tuple when the :if predicate tuple yields true" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: {AddAssign, {:some, "thing"}}
        )

      conn =
        :get
        |> conn("/")
        |> put_req_header("authorization", "super_secret")
        |> Unplug.call(opts)

      assert conn.assigns == %{some: "thing"}
    end

    test "should execute the :else tuple when the :if predicate tuple yields true" do
      opts =
        Unplug.init(
          if: {RequestHeaderEquals, {"authorization", "super_secret"}},
          do: {AddAssign, {:some, "thing"}},
          else: {AddAssign, {:other, "setting"}}
        )

      conn =
        :get
        |> conn("/")
        |> put_req_header("authorization", "invalid")
        |> Unplug.call(opts)

      assert conn.assigns == %{other: "setting"}
    end

    test "should accept anonymous functions for if/do/else" do
      opts =
        Unplug.init(
          if: fn c -> c.assigns[:thing] == "nice" end,
          do: fn c -> assign(c, :cool, "it's good") end,
          else: fn c -> assign(c, :no, "it's bad") end
        )

      conn =
        :get
        |> conn("/")
        |> Unplug.call(opts)

      assert conn.assigns == %{no: "it's bad"}

      conn =
        :get
        |> conn("/")
        |> assign(:thing, "nice")
        |> Unplug.call(opts)

      assert conn.assigns == %{cool: "it's good", thing: "nice"}
    end
  end
end
