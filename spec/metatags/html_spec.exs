defmodule Metatags.HTMLSpec do
  use ESpec, async: true
  use Plug.Test

  alias Metatags.HTML
  alias Phoenix.HTML.Safe

  describe "from_conn" do
    it "returns the metatags as html" do
      conn =
        build_conn()
        |> Metatags.put("title", "my title")

      expect(safe_to_string(HTML.from_conn(conn))).to(
        eq("<title>my title</title>")
      )
    end

    it "returns a Phoenix.HTML.Safe" do
      conn =
        build_conn()
        |> Metatags.put("title", "my title")

      expect(HTML.from_conn(conn)).to(match_pattern([{:safe, _}]))
    end

    it "raises an error when not passed a %Plug.Conn{}" do
      conn = %{}

      expect(fn ->
        HTML.from_conn(conn)
      end).to(raise_exception(ArgumentError))
    end

    it "prints a list of keywords as a comma separated string" do
      conn =
        build_conn()
        |> Metatags.put(:keywords, ["metatags", "awesome"])

      expect(safe_to_string(HTML.from_conn(conn))).to(
        have(~s(<meta content="metatags, awesome" name="keywords">))
      )
    end

    it "prints nested maps as keys with prefixes" do
      conn =
        build_conn()
        |> Metatags.put(:prefix, %{key: "value"})

      expect(safe_to_string(HTML.from_conn(conn))).to(
        have(~s(<meta content="value" name="prefix:key">))
      )
    end

    it "prints a key and value with name and content attributes" do
      conn =
        build_conn()
        |> Metatags.put(:anything, "value")

      expect(safe_to_string(HTML.from_conn(conn))).to(
        have(~s(<meta content="value" name="anything">))
      )
    end

    it "adds the sitename as suffix to title when configured", async: false do
      allow(Application).to(
        accept(
          :get_env,
          fn
            :metatags, :sitename -> "page"
            a, b -> passthrough([a, b])
          end,
          [:non_strict, :passthrough]
        )
      )

      conn =
        build_conn()
        |> Metatags.put(:title, "Welcome")

      expect(safe_to_string(HTML.from_conn(conn))).to(
        have("<title>Welcome - page</title>")
      )
    end

    it "prints the sitename when no title is set", async: false do
      allow(Application).to(
        accept(
          :get_env,
          fn
            :metatags, :sitename -> "page"
            a, b -> passthrough([a, b])
          end,
          [:non_strict, :passthrough]
        )
      )

      conn = build_conn()

      expect(safe_to_string(HTML.from_conn(conn))).to(
        have("<title>page</title>")
      )
    end
  end

  defp build_conn do
    :get
    |> conn("/")
    |> Metatags.call([])
  end

  defp safe_to_string(safe_string) do
    safe_string
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
