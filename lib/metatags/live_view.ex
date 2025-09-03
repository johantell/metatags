defmodule Metatags.LiveView do
  import Phoenix.LiveView, only: [attach_hook: 4]

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
