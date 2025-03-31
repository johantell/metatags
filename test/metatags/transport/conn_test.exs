defmodule Metatags.Transport.ConnTest do
  use ExUnit.Case, async: true

  alias Metatags.Config
  alias Metatags.Transport

  import Plug.Test

  describe "put/4" do
    test "puts a value inside the `Conn` private scope" do
      conn = build_conn()

      conn = Transport.put(conn, "title", "my title")

      assert %Plug.Conn{
               private: %{
                 metatags: %Metatags.Config{metatags: %{"title" => "my title"}}
               }
             } = conn
    end
  end

  describe "get_metatags/1" do
    test "returns a `Metatags.Config`" do
      conn = build_conn()

      assert %Config{} = Transport.get_metatags(conn)
    end
  end

  defp build_conn(default_metatags \\ []) do
    defaults = Metatags.Plug.init(default_metatags)

    :get
    |> conn("/")
    |> Metatags.Plug.call(defaults)
  end
end
