defmodule MetatagsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "put" do
    test "puts the passed metatag data into the %Plug.Conn{}" do
      conn = Metatags.put(build_conn(), "title", "my title")

      assert %{"title" => "my title"} == conn.private.metatags.metatags
    end

    test "allows atoms as keys" do
      conn = Metatags.put(build_conn(), :title, "my title")

      assert %{"title" => "my title"} == conn.private.metatags.metatags
    end
  end

  describe "print_tags" do
    test "returns the defined tags" do
      conn = Metatags.put(build_conn(), "title", "hello world")

      assert "<title>hello world</title>" =
               safe_to_string(Metatags.print_tags(conn))
    end
  end

  defp build_conn(default_metatags \\ []) do
    defaults = Metatags.Plug.init(default_metatags)

    :get
    |> conn("/")
    |> Metatags.Plug.call(defaults)
  end

  defp safe_to_string(safe_string) do
    safe_string
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
