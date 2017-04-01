# Metatags

Metatags provides an easy and flexible way to set both default and page specifig metatags that are used for SEO, facebook, twitter etc.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `metatags` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:metatags, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/metatags](https://hexdocs.pm/metatags).

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
```

And print them out inside your head tag
```html
<!DOCTYPE>
<html>
<head>
    <%= Metadata.print_tags(@conn) %>
</head>
<body>
</body>
</html>
```
