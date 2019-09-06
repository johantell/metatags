defmodule Metatags.Plug do
  @moduledoc """
  `Metatags.Plug` is a plug that can be used in a Plug router
  """

  alias Plug.Conn

  @behaviour Plug

  @default_metatags %{"title" => nil}

  @doc false
  def init(options) do
    default_tags = Keyword.get(options, :default_tags, [])
    sitename = Keyword.get(options, :sitename, nil)
    title_separator = Keyword.get(options, :title_separator, "-")

    default_tags =
      default_tags
      |> Enum.reduce(@default_metatags, fn {key, value}, default_tags ->
        Map.put(default_tags, to_string(key), value)
      end)

    %Metatags.Config{
      sitename: sitename,
      title_separator: title_separator,
      metatags: default_tags
    }
  end

  @doc false
  def call(conn, defaults) do
    Conn.put_private(conn, :metatags, defaults)
  end
end
