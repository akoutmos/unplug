defmodule Unplug do
  @moduledoc """
  This plug acts as a filter for Plug.Telemetry and allows you to filter out
  events based on the incoming URL.

  When servicing requests, Phoenix will log information about the incoming
  request and outgoing response. In some cases it may pollute the logs
  if certain endpoints are triggered and logged at regular intervals (for
  example logging for `/metrics` when using something like Prometheus to
  collect metrics or `/health` if you are health checking your application
  with Kubernetes).

  To use this in your application, open up your `endpoint.ex` file and replace:
  `plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]`

  with

  `plug TelemetryFilter, filter_endpoints: ["/metrics", "/health"], event_prefix: [:phoenix, :endpoint]`

  Feel free to replace the values for `:filter_endpoints` with whatever endpoints
  you would like to omit telemetry events for.
  """

  @behaviour Plug

  plug(Unplug, run_plug: Plug.Telemetry, run_plug_opts: [], eval: {Unplug}, eval_opts: [])

  @impl true
  def init(opts) do
    plug_telemetry_opts = Telemetry.init(opts)
    telemetry_filter_opts = Keyword.get(opts, :filter_endpoints, [])

    {plug_telemetry_opts, telemetry_filter_opts}
  end

  @impl true
  def call(conn, {plug_telemetry_opts, []}) do
    Telemetry.call(conn, plug_telemetry_opts)
  end

  def call(conn, {plug_telemetry_opts, telemetry_filter_opts}) do
    if Enum.member?(telemetry_filter_opts, conn.request_path) do
      conn
    else
      Telemetry.call(conn, plug_telemetry_opts)
    end
  end
end
