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
        %Conn{private: %{metatags: %Metatags.Config{} = metatags}} = conn,
        key,
        value
      ) do
    metatags = Metatags.Config.put_meta(metatags, key, value)

    Conn.put_private(conn, :metatags, metatags)
  end

  def get_metatags(%Conn{private: %{metatags: %Metatags.Config{} = metatags}}) do
    metatags
  end
end
