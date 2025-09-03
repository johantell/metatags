defmodule Metatags.LiveViewTest do
  use ExUnit.Case, async: true

  alias Phoenix.LiveView.Lifecycle
  alias Phoenix.LiveView.Socket

  describe "on_mount/4" do
    test "attaches a hook to put a canonical metatag on `handle_params`" do
      socket = build_socket()
      initial_config = [default_tags: %{"title" => "Welcome"}]
      params = %{}
      session = %{}

      {:cont, socket} =
        Metatags.LiveView.on_mount(
          {:init, initial_config},
          params,
          session,
          socket
        )

      assert %Lifecycle{handle_params: [%{id: :metatags_canonical}]} =
               read_lifecycle(socket)
    end

    test "puts the canonical tag upon handle params" do
      socket = build_socket() |> mount_socket()

      params = %{}

      {:cont, socket} =
        Lifecycle.handle_params(
          params,
          "http://example.com/path/",
          socket
        )

      assert %{"canonical" => "http://example.com/path/"} =
               Metatags.Transport.get_metatags(socket).metatags
    end
  end

  defp build_socket() do
    %Socket{router: :fake, private: %{lifecycle: %Lifecycle{}}}
  end

  defp mount_socket(socket) do
    initial_config = [default_tags: %{"title" => "Welcome"}]
    params = %{}
    session = %{}

    {:cont, socket} =
      Metatags.LiveView.on_mount(
        {:init, initial_config},
        params,
        session,
        socket
      )

    socket
  end

  defp read_lifecycle(%Socket{} = socket) do
    socket.private.lifecycle
  end
end
