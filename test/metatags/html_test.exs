defmodule Metatags.HTMLTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Metatags.Config
  alias Metatags.HTML
  alias Phoenix.HTML.Safe

  describe "from_metatags/1" do
    test "returns the metatags as html" do
      metatags = Config.put_meta(build_config(), "title", "my title")

      assert safe_to_string(HTML.from_metatags(metatags)) =~
               "<title>my title</title>"
    end

    test "returns a Phoenix.HTML.Safe" do
      conn = Config.put_meta(build_config(), "title", "my title")

      assert [{:safe, _}] = HTML.from_metatags(conn)
    end

    test "prints a list of keywords as a comma separated string" do
      conn = Config.put_meta(build_config(), :keywords, ["metatags", "awesome"])

      assert safe_to_string(HTML.from_metatags(conn)) =~
               ~s(<meta content="metatags, awesome" name="keywords">)
    end

    test "prints nested maps as keys with prefixes" do
      conn = Config.put_meta(build_config(), :prefix, %{key: "value"})

      assert safe_to_string(HTML.from_metatags(conn)) =~
               ~s(<meta content="value" name="prefix:key">)
    end

    test "prints a key and value with name and content attributes" do
      conn = Config.put_meta(build_config(), :anything, "value")

      assert safe_to_string(HTML.from_metatags(conn)) =~
               ~s(<meta content="value" name="anything">)
    end

    test "adds the sitename as suffix to title when configured" do
      default_options = [sitename: "page"]
      conn = Config.put_meta(build_config(default_options), :title, "Welcome")

      assert safe_to_string(HTML.from_metatags(conn)) =~
               "<title>Welcome - page</title>"
    end

    test "prints the sitename when no title is set" do
      default_options = [sitename: "page"]
      metatags = build_config(default_options)

      assert safe_to_string(HTML.from_metatags(metatags)) =~
               "<title>page</title>"
    end
  end

  defp build_config(defaults \\ []) do
    Config.build(defaults)
  end

  defp safe_to_string(safe_string) do
    safe_string
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
