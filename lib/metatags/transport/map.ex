defimpl Metatags.Transport, for: Map do
  @moduledoc false

  # Duck typing phoenix live view assigns as the full socket
  # isn't available on root layouts, where metatags are usually put.
  def get_metatags(%{__metatags__: metatags}) do
    metatags
  end

  # TODO: More helpful error messages
  def put(map, _, _, _ \\ []) do
    raise("""
    `Metatags.put/4` was used on a map

    #{inspect(map)}

    Whereas the recommended usage is to use it on a socket/plug.
    """)
  end

  def init(map, _options) do
    raise("""
    `Metatags.init/2` was used on a map

    #{inspect(map)}

    Whereas the recommended usage is to use it on a socket/plug.
    """)
  end
end
