# Metatags

[![CircleCI](https://circleci.com/gh/johantell/metatags.svg?style=svg)](https://circleci.com/gh/johantell/metatags)
[![Coverage Status](https://coveralls.io/repos/github/johantell/metatags/badge.svg?branch=master)](https://coveralls.io/github/johantell/metatags?branch=master)
[![Hex version](https://img.shields.io/hexpm/v/metatags.svg)](https://hex.pm/metatags)

Metatags provides an easy and flexible way to set both default and page specific metatags that are
used for SEO, Facebook, Twitter etc.

Documentation is available at [https://hexdocs.pm/metatags](https://hexdocs.pm/metatags).

## Installation

Add `metatags` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:metatags, "~> 0.5.0"}]
end
```

### For LiveView

Add the `on_mount` option to initialize and set up a hook to automatically set
the canonical url.

```elixir
@metatags_config = Application.compile_env(:my_app, Metatags)

live_session :default, on_mount: [{Metatags.LiveView, {:init, metatags_config}}]
```

In your live views `mount/3`/`handle_params/3`:

```elixir
def handle_params(_params, _url, socket) do
  socket =
    socket
    |> Metatags.put("author", "Johan Tell")
    |> Metatags.put("description", "My perfect description")

  {:ok, socket}
end

```

### For Plug

Add the plug to your router and configure the defaults
(You can use `Application.get_env/3` if you'd like to extract it into the
configuration file).

```elixir
defmodule MyRouter do
  use Plug.Conn

  plug Metatags.Plug,
    sitename: "My_app",
    title_separator: "-",
    default_tags: %{
      "title" => "Welcome!",
      "description" => "My_app is a great app",
      "keywords" => ["My_app", "great", "elixir"]
    }
```

## Usage

In your controller/live views put page specific data:
```elixir
conn
|> Metatags.put("title", "About My_app")
|> Metatags.put("description", "My app is just a regular app")
|> Metatags.put("og", %{"image" => "http://myimage.jpg"}) # You can have nested structures
|> Metatags.put("og:image", "http://myimage.jpg") # or define them inline
|> Metatags.put("canonical", "http://my-url.com")
|> Metatags.put("alternate", "http://en.my-url.com", hreflang: "en-GB")
```

And print them out inside your head tag
```elixir
<!DOCTYPE>
<html>
  <head>
    {Metatags.print_tags(@conn)}
  </head>
  <body>
    <h1>Welcome</h1>
  </body>
</html>
```
