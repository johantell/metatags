defimpl Metatags.Transport, for: Phoenix.LiveView.Socket do
  @moduledoc """
  An implementation of `Metatags.Transport` for `Phoenix.LiveView.Socket` where
  metatags is stored inside the `__metatags__` assign.

  To initialize the socket transport you'd likely want to create a
  custom plug which is called on mount.

    defmodule MyAppWeb.Metatags do
      @default_metatags %{
        "title" => "My page",
        "keywords" => ["Special page", "wow", "amazingness"]
        # ...
      }

      def on_mount(:init, session, socket) do
        {:cont, Metatags.init(socket, @default_metatags)}
      end
    end

  and call it from either your live view

    defmodule MyAppWeb.PageLive do
      use MyAppWeb, :live_view

      on_mount {MyAppWeb.Metatags, :init}
    end

  or put it in your router

    live_session "/", on_mount: [{MyAppWeb.Metatags, :init}] do
      # ...
    end

  """
  alias Phoenix.LiveView.Socket

  import Phoenix.Component, only: [assign: 3]

  @assign_name :__metatags__

  def put(%Socket{assigns: %{@assign_name => metatags}} = socket, key, value) do
    metatags = Metatags.Config.put_meta(metatags, key, value)

    assign(socket, @assign_name, metatags)
  end

  def get_metatags(%Socket{
        assigns: %{@assign_name => %Metatags.Config{} = metatags}
      }) do
    metatags
  end

  def init(%Socket{} = socket, config) do
    metatags = Metatags.Config.build(config)

    assign(socket, @assign_name, metatags)
  end
end

defimpl Metatags.Transport, for: Map do
  @moduledoc false

  # Duck typing phoenix live view assigns as the full socket
  # isn't available on root layouts, where metatags are usually put.
  def get_metatags(%{__metatags__: metatags}) do
    metatags
  end

  def put(_, _, _, _ \\ []), do: raise "Don't use this"
  def init(_, _options), do: raise "Don't use this"
end
