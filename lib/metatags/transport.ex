defprotocol Metatags.Transport do
  @moduledoc """
  Functions for transporting metatada along with the request lifecycle,
  whether it be a `Plug.Conn`, a `Phoenix.LiveView.Socket` or something else.
  """

  def put(transport, key, value)
  def get_metatags(transport)
end
