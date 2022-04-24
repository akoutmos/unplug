<!--START-->
<p align="center">
  <img align="center" width="30%" src="guides/images/logo.svg" alt="Unplug Logo">
  <img align="center" width="30%" src="guides/images/logo_text.png" alt="Unplug Logo">
</p>

<p align="center">
  Conditionally execute your plug modules at run-time in your Phoenix/Plug applications!
</p>

<p align="center">
  <a href="https://hex.pm/packages/unplug">
    <img alt="Hex.pm" src="https://img.shields.io/hexpm/v/unplug?style=for-the-badge">
  </a>

  <a href="https://github.com/akoutmos/unplug/actions">
    <img alt="GitHub Workflow Status (master)" src="https://img.shields.io/github/workflow/status/akoutmos/unplug/Unplug%20CI/master?label=Build%20Status&style=for-the-badge">
  </a>

  <a href="https://coveralls.io/github/akoutmos/unplug?branch=master">
    <img alt="Coveralls master branch" src="https://img.shields.io/coveralls/github/akoutmos/unplug/master?style=for-the-badge">
  </a>

  <a href="https://github.com/sponsors/akoutmos">
    <img alt="Support Unplug" src="https://img.shields.io/badge/Support%20Unplug-%E2%9D%A4-lightblue?style=for-the-badge">
  </a>
</p>

<br>
<!--END-->

# Contents

- [Installation](#installation)
- [Supporting Unplug](#supporting-unplug)
- [Setting Up Unplug](#setting-up-unplug)
- [Attribution](#attribution)

## Installation

The package can be installed by adding `:unplug` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:unplug, "~> 1.0.0"}
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

## Supporting Unplug

If you rely on Unplug in your applications, it would much appreciated if you can give back to the
project in order to help ensure its continued development.

Checkout my [GitHub Sponsorship page](https://github.com/sponsors/akoutmos) if you want to help out!

### Gold Sponsors

<a href="https://github.com/sponsors/akoutmos/sponsorships?sponsor=akoutmos&tier_id=58083">
  <img align="center" height="175" src="guides/images/your_logo_here.png" alt="Support the project">
</a>

### Silver Sponsors

<a href="https://github.com/sponsors/akoutmos/sponsorships?sponsor=akoutmos&tier_id=58082">
  <img align="center" height="150" src="guides/images/your_logo_here.png" alt="Support the project">
</a>

### Bronze Sponsors

<a href="https://smartlogic.io/" style="margin-right: 10px;" target="_blank">
  <img align="center" height="50" src="guides/images/smartlogic-logo-teal-400.png" alt="SmartLogic Consultancy">
</a>

<a href="https://github.com/sponsors/akoutmos/sponsorships?sponsor=akoutmos&tier_id=17615">
  <img align="center" height="125" src="guides/images/your_logo_here.png" alt="Support the project">
</a>

## Setting Up Unplug

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

The `:do` entry can be:

- A tuple where the first element is the plug module that you want to execute upon a truthy value from the
  predicate, and the second element being options that you want to send to that plug.
- A plug module that you want to execute upon a truthy value from the predicate. Without any options specified,
  Unplug will assume that an empty list should be sent to the plug's `init/1` function.

There is also an `:else` entry that can be provided to `Unplug`. The `:else` entry is identical to the `:do` entry
in terms of what it accepts as valid input. The `:else` entry is what is execute if the `:if` entry yields a falsey
value for the current request.

An example to show off the `:else` functionality could be something like this:

```elixir
plug Unplug,
  if: MyCoolApp.WhiteListedIPAddress,
  do: MyCoolApp.MetricsExporter,
  else: MyCoolApp.LogWarning
```

If the above example, we only want to expose our Prometheus metrics if the request is coming from a known safe source
(as a side note there are better ways to secure your metrics...don't use this in production).

### Provided Predicates

Unplug provides the following predicates out of the box:

| Predicate                                  | Description                                                                                                                   |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `Unplug.Predicates.AppConfigEquals`        | Given an application and a key, execute the plug if the configured value matches the expected value                           |
| `Unplug.Predicates.AppConfigNotEquals`     | Given an application and a key, do not execute the plug if the configured value matches the expected value                    |
| `Unplug.Predicates.AppConfigIn`            | Given an application and a key, execute the plug if the configured value is in the provided enumerable of values              |
| `Unplug.Predicates.AppConfigNotIn`         | Given an application and a key, execute the plug if the configured value is not in the provided enumerable of values          |
| `Unplug.Predicates.EnvVarEquals`           | Given an environment variable, execute the plug if the configured value matches the expected value                            |
| `Unplug.Predicates.EnvVarNotEquals`        | Given an environment variable, do not execute the plug if the configured value matches the expected value                     |
| `Unplug.Predicates.EnvVarIn`               | Given an environment variable, execute the plug if the environment variable value is in the provided enumerable of values     |
| `Unplug.Predicates.EnvVarNotIn`            | Given an environment variable, execute the plug if the environment variable value is not in the provided enumerable of values |
| `Unplug.Predicates.RequestHeaderEquals`    | Given a request header, execute the plug if the request value matches the expected value                                      |
| `Unplug.Predicates.RequestHeaderNotEquals` | Given a request header, do not execute the plug if the request value matches the expected value                               |
| `Unplug.Predicates.RequestPathEquals`      | Given a request path, execute the plug if the request value matches the expected value                                        |
| `Unplug.Predicates.RequestPathNotEquals`   | Given a request path, do not execute the plug if the request value matches the expected value                                 |
| `Unplug.Predicates.RequestPathIn`          | Given a request path, execute the plug if the request value is in the provided enumerable of values                           |
| `Unplug.Predicates.RequestPathNotIn`       | Given a request path, do not execute the plug if the request value is in the provided enumerable of values                    |

### Writing Your Own Predicates

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

## Attribution

- The logo for the project is an edited version of an SVG image from the [unDraw project](https://undraw.co/)
