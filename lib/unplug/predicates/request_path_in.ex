defmodule Unplug.Predicates.RequestPathIn do
  @moduledoc """
  Given a request path, execute the plug if the request value is in
  the the provided list of values.

  Usage:
  ```elixir
  plug Unplug,
    if: {Unplug.Predicates.RequestPathIn, ["/users", "/auth"]},
    do: MyApp.Plug
  ```
  """

  @behaviour Unplug.Predicate

  @impl true
  def call(conn, opts) do
    Enum.reduce_while(opts, false, fn
      req_path_check, acc when is_binary(req_path_check) ->
        if String.equivalent?(req_path_check, conn.request_path),
          do: {:halt, true},
          else: {:cont, acc}

      %Regex{} = req_path_check, acc ->
        if Regex.match?(req_path_check, conn.request_path),
          do: {:halt, true},
          else: {:cont, acc}

      _, acc ->
        {:cont, acc}
    end)
  end
end
