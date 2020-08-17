defmodule Metatags.HTML.TagBuilderTest do
  use ExUnit.Case, async: true

  alias Metatags.Config
  alias Metatags.HTML.TagBuilder
  alias Phoenix.HTML.Safe

  describe "print_tag/4" do
    test "prints `title` with a `<title>` element" do
      metatags = %{}
      config = %Config{}

      result = TagBuilder.print_tag(metatags, "title", "my title", config)

      assert safe_to_string(result) == "<title>my title</title>"
    end

    test "prints `next` with a `<link>` element" do
      metatags = %{}
      config = %Config{}

      result =
        TagBuilder.print_tag(metatags, "next", "https://example.com", config)

      assert safe_to_string(result) ==
               ~s(<link href="https://example.com" rel="next">)
    end

    test "prints `canonical` with a `<link>` element" do
      metatags = %{}
      config = %Config{}

      result =
        TagBuilder.print_tag(
          metatags,
          "canonical",
          "https://example.com",
          config
        )

      assert safe_to_string(result) ==
               ~s(<link href="https://example.com" rel="canonical">)
    end

    test "prints `alternate` with a `<link>` element" do
      metatags = %{}
      config = %Config{}

      result =
        TagBuilder.print_tag(
          metatags,
          "alternate",
          "https://example.com",
          config
        )

      assert safe_to_string(result) ==
               ~s(<link href="https://example.com" rel="alternate">)
    end

    test "prints `alternate` with a `<link>` element and extra attributes" do
      metatags = %{}
      config = %Config{}

      result =
        TagBuilder.print_tag(
          metatags,
          "alternate",
          {"https://example.com", hreflang: "sv-SE"},
          config
        )

      assert safe_to_string(result) ==
               ~s(<link href="https://example.com" hreflang="sv-SE" rel="alternate">)
    end

    test "prints `apple-touch-icon-precomposed` with a `<link>` element and extra attributes" do
      metatags = %{}
      config = %Config{}

      result =
        TagBuilder.print_tag(
          metatags,
          "apple-touch-icon-precomposed",
          {"favicon.png", sizes: "144x144"},
          config
        )

      assert safe_to_string(result) ==
               ~s(<link href="favicon.png" rel="apple-touch-icon-precomposed" sizes="144x144">)
    end

    test "prints `apple-touch-icon-precomposed` with a `<link>` element" do
      metatags = %{}
      config = %Config{}

      result =
        TagBuilder.print_tag(
          metatags,
          "apple-touch-icon-precomposed",
          "favicon.png",
          config
        )

      assert safe_to_string(result) ==
               ~s(<link href="favicon.png" rel="apple-touch-icon-precomposed">)
    end
  end

  defp safe_to_string(safe_string) do
    safe_string
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
