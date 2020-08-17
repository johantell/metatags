defmodule Metatags.HTML do
  @moduledoc """
  Transforms metatags to HTML
  """

  alias Metatags.HTML.TagBuilder

  @doc """
  Turns a `%Plug.Conn{}` with metatags into HTML
  """
  @spec from_conn(Plug.Conn.t()) :: Phoenix.HTML.safe()
  def from_conn(%Plug.Conn{private: %{metatags: metatags}}) do
    {metatags, config} = Map.pop(metatags, :metatags)

    Enum.reduce(metatags, [], fn {key, value}, acc ->
      [TagBuilder.print_tag(metatags, key, value, config) | acc]
    end)
  end

  def from_conn(_) do
    raise ArgumentError,
      message:
        "No metatags was present in the passed struct. Did you forget to add it?"
  end
end
