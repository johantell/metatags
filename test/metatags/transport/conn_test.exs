defmodule Metatags.Transport.ConnTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Metatags.Config
  alias Metatags.Transport

  describe "put/4" do
    test "assigns the metatags to the `Plug.Conn`" do
      conn = build_conn()

      conn = Transport.put(conn, "title", "my title")

      assert %Plug.Conn{
               assigns: %{
                 __metatags__: %Metatags.Config{}
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
    :get
    |> conn("/")
    |> Metatags.init(default_metatags)
  end
end
