defmodule Metatags.HTML do
  @moduledoc """
  Transforms metatags to HTML
  """

  alias Phoenix.HTML
  alias Phoenix.HTML.Tag

  @doc """
  Turns a %Plug.Plug.Conn{} with metatags into HTML
  """
  @spec from_conn(Plug.Conn.t()) :: HTML.Safe.t()
  def from_conn(%Plug.Conn{private: %{metatags: metatags}}) do
    metatags
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metatags, key, value) | acc]
    end)
  end

  def from_conn(_) do
    raise ArgumentError,
      message: """
      No metatags was present in the passed struct.
      Did you forget to add it?
      """
  end

  defp print_tag(metatags, prefix, %{} = map) do
    map
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metatags, "#{prefix}:#{key}", value) | acc]
    end)
  end

  defp print_tag(_, "title", value) when is_nil(value),
    do: Tag.content_tag(:title, do: sitename())

  defp print_tag(_, "title", value) do
    suffix = if sitename(), do: [separator(), sitename()], else: []

    Tag.content_tag(:title, do: Enum.join([value] ++ suffix, " "))
  end

  defp print_tag(metatags, "keywords" = key, value) when is_list(value) do
    print_tag(metatags, key, Enum.join(value, ", "))
  end

  defp print_tag(_, key, value) do
    Tag.tag(:meta, name: key, content: value)
  end

  defp sitename, do: Application.get_env(:metatags, :sitename)
  defp separator, do: Application.get_env(:metatags, :separator, "-")
end
