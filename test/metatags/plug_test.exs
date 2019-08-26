defmodule Metatags.PlugTest do
  use ExUnit.Case, async: true

  describe "init/1" do
    test "returns the defaults when passed an empty map" do
      assert %Metatags.Config{
               metatags: %{"title" => nil},
               title_separator: "-",
               sitename: nil
             } ==
               Metatags.Plug.init([])
    end

    test "merges the passed config with the defaults" do
      config = [sitename: "sitename", title_separator: "|"]

      assert %{title_separator: "|", sitename: "sitename"} =
               Metatags.Plug.init(config)
    end

    test "merges the passed `default_tags` with the predefined metatags" do
      default_tags = [
        title: "Welcome",
        description: "a description"
      ]

      assert %{
               metatags: %{
                 "title" => "Welcome",
                 "description" => "a description"
               }
             } = Metatags.Plug.init(default_tags: default_tags)
    end
  end

  describe "call/2" do
    test "puts the metatags config on the `Plug.Conn` struct" do
      conn = %Plug.Conn{}

      metatags = %Metatags.Config{
        metatags: %{"title" => nil, "description" => "a description"}
      }

      assert %{private: %{metatags: ^metatags}} =
               Metatags.Plug.call(conn, metatags)
    end
  end
end
