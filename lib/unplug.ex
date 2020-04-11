defmodule Unplug do
  @moduledoc """
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestPathIn, ["/metrics", "healthcheck"]}
    do: {Plug.Telemetry, event_prefix: [:phoenix, :endpoint]}
    else: SomeOther.Plug
  ```

  predicates:
  RequestPathEquals "/metrics"
  RequestPathNotEquals "/metrics"

  RequestPathIn ["/metrics", "/healthcheck"]
  RequestPathNotIn ["/metrics", "/healthcheck"]

  RequestHeaderEquals {header, "expected_value"}
  RequestHeaderNotEquals {header, "expected_value"}

  EnvVarEquals {"PLUG_ENABLED", "true"}
  EnvVarNotEquals {"PLUG_ENABLED", "true"}

  AppConfigEquals {:app, :key, "expected_value"}
  AppConfigNotEquals {:app, :key, "expected_value"}
  """

  @behaviour Plug

  @impl true
  def init(opts) do
    # Fetch all of the required options and raise if there are any errors
    init_mode = Application.get_env(:unplug, :init_mode, :compile)
    if_condition = Keyword.get(opts, :if) || raise "Unplug requires an :if condition entry"
    do_plug = Keyword.get(opts, :do) || raise "Unplug requires a :do plug entry"
    else_plug = Keyword.get(opts, :else, :skip)

    # Evaluate conditional plug inits if configured to do so
    do_plug_init_opts = eval_plug_init(init_mode, do_plug)
    else_plug_init_opts = eval_plug_init(init_mode, else_plug)

    {init_mode,
     %{
       if_condition: if_condition,
       do_plug: do_plug,
       do_plug_init_opts: do_plug_init_opts,
       else_plug: else_plug,
       else_plug_init_opts: else_plug_init_opts
     }}
  end

  @impl true
  def call(conn, {:compile, unplug_opts}) do
    %{
      if_condition: if_condition,
      do_plug: do_plug,
      do_plug_init_opts: do_plug_init_opts,
      else_plug: else_plug,
      else_plug_init_opts: else_plug_init_opts
    } = unplug_opts

    cond do
      exec_if_condition_call(conn, if_condition) ->
        exec_plug_call(conn, do_plug, do_plug_init_opts)

      else_plug != :skip ->
        exec_plug_call(conn, else_plug, else_plug_init_opts)

      true ->
        conn
    end
  end

  def call(conn, {:runtime, unplug_opts}) do
    %{
      if_condition: if_condition,
      do_plug: do_plug,
      else_plug: else_plug
    } = unplug_opts

    cond do
      exec_if_condition_call(conn, if_condition) ->
        do_plug_init_opts = eval_plug_init(:compile, do_plug)
        exec_plug_call(conn, do_plug, do_plug_init_opts)

      else_plug != :skip ->
        else_plug_init_opts = eval_plug_init(:compile, else_plug)
        exec_plug_call(conn, else_plug, else_plug_init_opts)

      true ->
        conn
    end
  end

  defp eval_plug_init(:compile, :skip), do: :skip
  defp eval_plug_init(:compile, {plug, opts}), do: plug.init(opts)
  defp eval_plug_init(:compile, plug), do: plug.init([])
  defp eval_plug_init(:runtime, :skip), do: :skip
  defp eval_plug_init(:runtime, _plug), do: nil
  defp eval_plug_init(bad_arg, _plug), do: raise("Invalid value #{inspect(bad_arg)} for Unplug config :init_mode")

  defp exec_if_condition_call(conn, {filter_module, filter_opts}), do: filter_module.call(conn, filter_opts)
  defp exec_if_condition_call(conn, filter_module), do: filter_module.call(conn, [])

  defp exec_plug_call(conn, {plug_module, _init_opts}, plug_opts), do: plug_module.call(conn, plug_opts)
  defp exec_plug_call(conn, plug_module, plug_opts), do: plug_module.call(conn, plug_opts)
end
