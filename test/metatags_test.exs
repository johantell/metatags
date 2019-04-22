defmodule MetatagsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "init" do
    test "returns nil" do
      assert nil == Metatags.init([])
    end
  end

  describe "call" do
    test "sets the default metatags" do
      conn =
        conn(:get, "/")
        |> Metatags.call([])

      assert %{"title" => nil} == conn.private.metatags
    end
  end

  describe "put" do
    test "puts the passed metatag data into the %Plug.Conn{}" do
      conn =
        build_conn()
        |> Metatags.put("title", "my title")

      assert %{"title" => "my title"} == conn.private.metatags
    end

    test "allows atoms as keys" do
      conn =
        build_conn()
        |> Metatags.put(:title, "my title")

      assert %{"title" => "my title"} == conn.private.metatags
    end
  end

  describe "print_tags" do
    test "returns the defined tags" do
      conn = Metatags.put(build_conn(), "title", "hello world")

      assert "<title>hello world</title>" = safe_to_string(Metatags.print_tags(conn))
    end
  end

  defp build_conn do
    conn(:get, "/")
    |> Metatags.call([])
  end

  defp safe_to_string(safe_string) do
    safe_string
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
