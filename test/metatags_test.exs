defmodule MetatagsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "put/3" do
    test "puts the passed metatag data into the %Plug.Conn{}" do
      conn = Metatags.put(build_conn(), "title", "my title")

      assert %{"title" => "my title"} =
               Metatags.Transport.get_metatags(conn).metatags
    end

    test "allows atoms as keys" do
      conn = Metatags.put(build_conn(), :title, "my title")

      assert %{"title" => "my title"} =
               Metatags.Transport.get_metatags(conn).metatags
    end
  end

  describe "put/4" do
    test "puts the value and extra attributes into the %Plug.Conn{}" do
      conn =
        Metatags.put(build_conn(), "canonical", "https://example.com/",
          hreflang: "sv-SE"
        )

      assert %{"canonical" => {"https://example.com/", [hreflang: "sv-SE"]}} =
               Metatags.Transport.get_metatags(conn).metatags
    end
  end

  describe "print_tags/1" do
    test "returns the defined tags" do
      conn = Metatags.put(build_conn(), "title", "hello world")

      assert safe_to_string(Metatags.print_tags(conn)) =~
               "<title>hello world</title>"
    end

    test "sets a missing canonical metatag to current url" do
      default_options = []
      conn = build_conn(default_options)

      assert safe_to_string(Metatags.print_tags(conn)) =~
               ~s(<link href="http://www.example.com/" rel="canonical">)
    end

    test "ignores query params when setting an automated canonical url" do
      default_metatags = []

      conn =
        :get
        |> conn("/path/?query=params")
        |> Metatags.init(default_metatags)

      assert safe_to_string(Metatags.print_tags(conn)) =~
               ~s(<link href="http://www.example.com/path/" rel="canonical">)
    end
  end

  defp build_conn(default_metatags \\ []) do
    :get
    |> conn("/")
    |> Metatags.init(default_metatags)
  end

  defp safe_to_string(safe_string) do
    safe_string
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
