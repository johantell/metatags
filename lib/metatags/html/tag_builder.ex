defmodule Metatags.HTML.TagBuilder do
  alias Phoenix.HTML.Tag

  @type metatags_struct :: struct()

  @spec print_tag(metatags_struct(), String.t(), any(), Metatags.Config.t()) ::
          HTML.Safe.t()
  def print_tag(metatags, prefix, %{} = map, config) do
    map
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metatags, "#{prefix}:#{key}", value, config) | acc]
    end)
  end

  def print_tag(_, "title", nil, %{sitename: nil}), do: ""

  def print_tag(_, "title", value, %{sitename: sitename}) when is_nil(value) do
    Tag.content_tag(:title, do: sitename)
  end

  def print_tag(_, "title", value, %{
        sitename: sitename,
        title_separator: separator
      }) do
    suffix = if sitename, do: [separator, sitename], else: []

    Tag.content_tag(:title, do: Enum.join([value] ++ suffix, " "))
  end

  def print_tag(metatags, "keywords", value, config)
      when is_list(value) do
    print_tag(metatags, "keywords", Enum.join(value, ", "), config)
  end

  def print_tag(_, key, value, _) do
    Tag.tag(:meta, name: key, content: value)
  end
end
