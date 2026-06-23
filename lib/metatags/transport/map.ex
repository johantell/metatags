defimpl Metatags.Transport, for: Map do
  @moduledoc false

  # Duck typing phoenix live view assigns as the full socket
  # isn't available on root layouts, where metatags are usually put.
  def get_metatags(%{__metatags__: metatags}) do
    metatags
  end

  @spec put(map(), String.t() | atom(), any()) :: no_return()
  def put(map, _, _) do
    raise("""
    `Metatags.put/3` was used on a map

    #{inspect(map)}

    Whereas the recommended usage is to use it on a socket/plug.
    """)
  end

  @spec init(map(), Keyword.t()) :: no_return()
  def init(map, _options) do
    raise("""
    `Metatags.init/2` was used on a map

    #{inspect(map)}

    Whereas the recommended usage is to use it on a socket/plug.
    """)
  end
end
