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
  [{:metatags, "~> 0.2.0"}]
end
```

Configure the defaults in confix.ex

```elixir
config :metatags,
    sitename: "My_app",
    separator: "-",
    default_tags: %{
        "title" => "Welcome!",
        "description" => "My_app is a great app",
        "keywords" => ["My_app", "great", "elixir"]
    }
```

## Usage

Add metatags as a plug. either directly in a scope or into a Phoenix pipeline
```elixir
plug Metatags
```

In your controller put page specific data
```elixir
conn
|> Metatags.put("title", "About My_app")
|> Metatags.put("og", %{"image" => "http://myimage.jpg"})
```

And print them out inside your head tag
```html
<!DOCTYPE>
<html>
<head>
    <%= Metatags.print_tags(@conn) %>
</head>
<body>
</body>
</html>
```
