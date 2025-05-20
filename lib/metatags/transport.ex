defprotocol Metatags.Transport do
  @moduledoc """
  Functions for transporting metatada along with the request lifecycle,
  whether it be a `Plug.Conn`, a `Phoenix.LiveView.Socket` or something else.
  """

  @type t :: struct()

  @spec put(t(), String.t() | atom(), any()) :: t()
  def put(transport, key, value)

  @spec get_metatags(t()) :: Metatags.Config.t()
  def get_metatags(transport)
  def canonical_url(transport)
end
