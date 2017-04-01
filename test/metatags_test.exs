defmodule MetatagsTest do
  use ExUnit.Case
  use Plug.Test
  doctest Metatags

  @opts Metatags.init([])

  def to_binary(safe_string) do
    safe_string
    |> Phoenix.HTML.Safe.to_iodata
    |> IO.iodata_to_binary
  end

  test "using it as plug creates a metadata struct" do
    conn = Metatags.call(conn(:get, "/"), @opts)

    assert conn.metadata == %{}
  end

  test "puts data into metadata" do
    conn = :get
    |> conn("/")
    |> Metatags.call(@opts)
    |> Metatags.put("description", "cool stuff")

    assert conn.metadata["description"] == "cool stuff"
  end

  test "converts atom key to string while using put" do
    metadata = %{metadata: %{}}
    |> Metatags.put(:title, "My title")

    assert metadata == %{metadata: %{"title" => "My title"}}
  end

  test "prints a metatag as a safe string" do
    result = %{metadata: %{"description" => "cool stuff"}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<meta content="cool stuff" name="description">)
  end

  test "prints a metatag with prefixes (recursively)" do
    result = %{metadata: %{"og" => %{"title" => "my title"}}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<meta content="my title" name="og:title">)
  end

  test "prints title in a title tag" do
    result = %{metadata: %{"title" => "my title"}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<title>my title</title>)
  end

  test "when title is nil use sitename" do
    result = %{metadata: %{"title" => nil}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<title></title>)
  end

  test "can handle atom keys" do
    result = %{metadata: %{title: "my title"}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<title>my title</title>)
  end

  test "handling of keywords" do
    result = %{metadata: %{keywords: ["some", "keywords"]}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<meta content="some, keywords" name="keywords">)
  end

  test "inherits og:url from canonical when og:url is nil" do
    result = %{metadata: %{"canonical" => "/path", og: %{ "url" => nil }}}
    |> Metatags.print_tags()
    |> to_binary

    assert result == ~s(<meta content="/path" name="canonical"><meta content="/path" name="og:url">)
  end
end
