defmodule Metatags.HTML do
  @moduledoc """
  Transforms metatags to HTML
  """

  alias Metatags.Config
  alias Metatags.HTML.TagBuilder

  @doc """
  Turns a `%Plug.Conn{}` with metatags into HTML
  """
  @spec from_metatags(Config.t()) :: Phoenix.HTML.safe()
  def from_metatags(%Config{} = config) do
    {metatags, config} = Map.pop(config, :metatags)

    Enum.reduce(metatags, [], fn {key, value}, acc ->
      [TagBuilder.print_tag(metatags, key, value, config) | acc]
    end)
  end
end
