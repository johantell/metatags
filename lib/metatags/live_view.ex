defmodule Metatags.LiveView do
  @moduledoc """
  Live-view specific helpers meant to be used by the integrating application.

  currently only contains the `on_mount/4` hook which will be called through the
  routers `live_session` function:

  ```elixir
  @default_metatags Application.compile_env(:my_app, Metatags)
  live_session :default, on_mount: [{Metatags.LiveView, {:init, @default_metatags}}] do
    # ...
  end
  ```
  """
  import Phoenix.LiveView, only: [attach_hook: 4]

  @doc """
  callback to be ran when mounting a live view. It initializes the live view
  configuration onto the socket and attaches a hook on `handle_params` to automatically
  put the canonical uri into the configuration.
  """
  def on_mount({:init, default_metatags}, _params, _session, socket) do
    socket =
      socket
      |> Metatags.init(default_metatags)
      |> attach_hook(:metatags_canonical, :handle_params, &put_canonical/3)

    {:cont, socket}
  end

  defp put_canonical(_session, url, socket) do
    canoniocal_uri =
      url
      |> URI.parse()
      |> Map.put(:query, nil)
      |> URI.to_string()

    {:cont, Metatags.put(socket, "canonical", canoniocal_uri)}
  end
end
