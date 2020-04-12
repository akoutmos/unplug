# Unplug

[![Hex.pm](https://img.shields.io/hexpm/v/unplug.svg)](http://hex.pm/packages/unplug) [![Build Status](https://travis-ci.org/akoutmos/unplug.svg?branch=master)](https://travis-ci.org/akoutmos/unplug) [![Coverage Status](https://coveralls.io/repos/github/akoutmos/unplug/badge.svg?branch=master)](https://coveralls.io/github/akoutmos/unplug?branch=master)

## Installation

The package can be installed by adding `:unplug` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:unplug, "~> 0.1.0"}
  ]
end
```

After adding `:unplug` to your list of dependency, open up your `config/dev.exs` config file and
add the following:

```elixir
...

config :unplug, :init_mode, :runtime

...
```

This will make it so that your plug `init/1` functions are not compiled for a quicker development
experience and is in line with Phoenix and Plug conventions.

With those in place, you are all set and ready to use Unplug

## Usage

Unplug can be used anywhere you would typically use the `plug` macro. For example, let's say you want
to skip the `Plug.Telemetry` plug for certain routes (to cut down on noise in your logs for example).
To do so, you would replace the following:

```elixir
plug Plug.Telemetry
```

with the following:

```elixir
plug Unplug,
    if: {Unplug.Predicates.RequestPathNotIn, ["/metrics", "/healthcheck"]},
    do: {Plug.Telemetry, event_prefix: [:phoenix, :endpoint]}
```

or with the following if no configuration is required of `Plug.Telemetry`:

```elixir
plug Unplug,
    if: {Unplug.Predicates.RequestPathNotIn, ["/metrics", "/healthcheck"]},
    do: Plug.Telemetry
```

Let's break this down a bit so we can understand what is going on. `Unplug` takes a `KeywordList` of options
that specifies how it will evaluate the request.

The `:if` entry can be:

- A tuple with the first element being the predicate module and the second element being the options to send to
  the predicate (a predicate is a module that implements the `Unplug.Predicate` behavior).
- A module that implements the `Unplug.Predicate` behavior. Without any predicate options being specified, an
  empty list is sent as the second argument to the predicate's `call/2` function.
- An anonymous function of arity one. That one argument being the `conn` for the current request.

The `:do` entry can be:

- A tuple where the first element is the plug module that you want to execute upon a truthy value from the
  predicate, and the second element being options that you want to send to that plug.
- A plug module that you want to execute upon a truthy value from the predicate. Without any options specified,
  Unplug will assume that an empty list should be sent to the plug's `init/1` function.
- An anonymous function that takes one argument, with that argument being the current request's `conn`. This
  function must also return a `Plug.Conn` struct.

There is also an `:else` entry that can be provided to `Unplug`. The `:else` entry is identical to the `:do` entry
in terms of what it accepts as valid input. The `:else` entry is what is execute if the `:if` entry yields a falsey
value for the current request.

Another example to show off the anonymous function and `:else` functionality could be something like this:

```elixir
plug Unplug,
  if: fn conn -> conn.remote_ip == {10, 0, 0, 1} end,
  do: plug MyCoolApp.MetricsExporter,
  else: fn conn ->
    Logger.warn("Someone is trying to steal my metrics!")
    conn
  end,
```

If the above example, we only want to expose our Prometheus metrics if the request is coming from a known safe source
(as a side note there are better ways to secure your metrics...don't use this in production).

## Provided Predicates

Unplug provides the following predicates out of the box:

- `Unplug.Predicates.AppConfigEquals`:
- `Unplug.Predicates.AppConfigNotEquals`:
- `Unplug.Predicates.EnvVarEquals`:
- `Unplug.Predicates.EnvVarNotEquals`:
- `Unplug.Predicates.RequestHeaderEquals`:
- `Unplug.Predicates.RequestHeaderNotEquals`:
- `Unplug.Predicates.RequestPathEquals`:
- `Unplug.Predicates.RequestPathNotEquals`:
- `Unplug.Predicates.RequestPathIn`:
- `Unplug.Predicates.RequestPathNotIn`:

## Writing Your Own Predicates

To write your own Unplug predicate, all you have to do is implement the `Unplug.Predicate` behavior and provide
a `call/2` function that will return a boolean value.

For example, if we wanted to have a plug conditionally execute only when the request method equals a certain value,
we could create the following predicate module:

```elixir
defmodule MyApp.UnplugPredicates.MethodEquals do
  @behaviour Unplug.Predicate

  @impl true
  def call(%Plug.Conn{method: req_method}, opt_method), do: req_method == opt_method
end
```

and use it like so:

```elixir
plug Unplug,
  if: {MyApp.UnplugPredicates.MethodEquals, "DELETE"},
  do: MyApp.MyPlugs.DeleteAuditLoggerPlug
```
