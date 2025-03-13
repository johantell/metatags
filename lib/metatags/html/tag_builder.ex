defmodule Metatags.HTML.TagBuilder do
  @moduledoc false

  @type metatags_struct :: struct()

  @spec print_tag(metatags_struct(), String.t(), any(), Metatags.Config.t()) ::
          Phoenix.HTML.safe()
  def print_tag(metatags, prefix, %{} = map, config) do
    Enum.reduce(map, [], fn {key, value}, acc ->
      [print_tag(metatags, "#{prefix}:#{key}", value, config) | acc]
    end)
  end

  def print_tag(_, "title", nil, %{sitename: nil}), do: ""

  def print_tag(_, "title", value, %{sitename: sitename}) when is_nil(value) do
    content_tag(:title, do: sitename)
  end

  def print_tag(_, "title", value, %{
        sitename: sitename,
        title_separator: separator
      }) do
    suffix = if sitename, do: [separator, sitename], else: []

    content_tag(:title, do: Enum.join([value] ++ suffix, " "))
  end

  def print_tag(metatags, "keywords", value, config)
      when is_list(value) do
    print_tag(metatags, "keywords", Enum.join(value, ", "), config)
  end

  def print_tag(_, "next" = name, value, _) when is_binary(value) do
    tag(:link, rel: name, href: value)
  end

  def print_tag(_, "canonical" = name, value, _) when is_binary(value) do
    tag(:link, rel: name, href: value)
  end

  def print_tag(_, "alternate" = name, {value, extra_attributes}, _)
      when is_list(extra_attributes) do
    tag(:link, [rel: name, href: value] ++ extra_attributes)
  end

  def print_tag(_, "alternate" = name, value, _) when is_binary(value) do
    tag(:link, rel: name, href: value)
  end

  def print_tag(_, "apple-touch-icon-precomposed" = name, value, _)
      when is_binary(value) do
    tag(:link, rel: name, href: value)
  end

  def print_tag(
        _,
        "apple-touch-icon-precomposed" = name,
        {value, extra_attributes},
        _
      )
      when is_list(extra_attributes) do
    tag(:link, [rel: name, href: value] ++ extra_attributes)
  end

  def print_tag(_, key, value, _) do
    tag(:meta, name: key, content: value)
  end

  defp tag(type, attributes) do
    formatted_attributes =
      attributes
      |> Enum.sort_by(fn {key, _value} -> attribute_prio(key) end, :desc)
      |> Enum.map_join(" ", fn {key, value} -> ~s(#{key}="#{value}") end)

    {:safe, ~s(<#{type} #{formatted_attributes}>)}
  end

  defp content_tag(type, do: content) do
    {:safe, ~s(<#{type}>#{content}</#{type}>)}
  end

  @order_index ~w[
    sizes
    name
    content
    rel
    hreflang
    href
  ]

  defp attribute_prio(attribute) do
    Enum.find_index(@order_index, fn item -> item == to_string(attribute) end)
  end
end
