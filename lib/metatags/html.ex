defmodule Metatags.HTML do
  @moduledoc """
  Transforms metatags to HTML
  """

  alias Phoenix.HTML
  alias Phoenix.HTML.Tag

  @doc """
  Turns a `%Plug.Conn{}` with metatags into HTML
  """
  @spec from_conn(Plug.Conn.t()) :: HTML.Safe.t()
  def from_conn(%Plug.Conn{private: %{metatags: metatags}}) do
    {metatags, config} = Map.pop(metatags, :metatags)

    Enum.reduce(metatags, [], fn {key, value}, acc ->
      [print_tag(metatags, key, value, config) | acc]
    end)
  end

  def from_conn(_) do
    raise ArgumentError,
      message:
        "No metatags was present in the passed struct. Did you forget to add it?"
  end

  defp print_tag(metatags, prefix, %{} = map, config) do
    map
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metatags, "#{prefix}:#{key}", value, config) | acc]
    end)
  end

  defp print_tag(_, "title", nil, %{sitename: nil}), do: ""

  defp print_tag(_, "title", value, %{sitename: sitename}) when is_nil(value) do
    Tag.content_tag(:title, do: sitename)
  end

  defp print_tag(_, "title", value, %{
         sitename: sitename,
         title_separator: separator
       }) do
    suffix = if sitename, do: [separator, sitename], else: []

    Tag.content_tag(:title, do: Enum.join([value] ++ suffix, " "))
  end

  defp print_tag(metatags, "keywords", value, config)
       when is_list(value) do
    print_tag(metatags, "keywords", Enum.join(value, ", "), config)
  end

  defp print_tag(_, key, value, _) do
    Tag.tag(:meta, name: key, content: value)
  end
end
