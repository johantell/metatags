defimpl Metatags.Transport, for: Plug.Conn do
  @moduledoc """
  An implementation of `Metatags.Transport` for `Plug.Conn` where
  metatags is stored inside the `private` key of the `Conn` struct.

  To initialize the `Conn` transport you'd likely want to create a
  custom plug which is called on every request.

      defmodule MyApp.Plug.MetatagsPlug do

        def init(conn, opts) do
        end

        def call(conn, opts) do
        end
      end
    
  """
  alias Plug.Conn

  def put(
        %Conn{assigns: %{__metatags__: %Metatags.Config{} = metatags}} = conn,
        key,
        value
      ) do
    metatags = Metatags.Config.put_meta(metatags, key, value)

    Conn.assign(conn, :__metatags__, metatags)
  end

  def get_metatags(%Conn{
        assigns: %{__metatags__: %Metatags.Config{} = metatags}
      }) do
    metatags
  end

  def canonical_url(%Conn{} = conn) do
    Conn.request_url(%{conn | query_string: ""})
  end

  def init(%Conn{} = conn, config) do
    metatags = Metatags.Config.build(config)

    conn
    |> Conn.assign(:__metatags__, metatags)
    |> Metatags.put(:canonical, canonical_url(conn))
  end
end
