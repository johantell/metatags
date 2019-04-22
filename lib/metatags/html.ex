defmodule Metatags.HTML do
  @moduledoc """
  Transforms metatags to HTML
  """

  alias Phoenix.HTML
  alias Phoenix.HTML.Tag

  @type base_option :: {:sitename, String.t()} | {:separator, String.t()} | {:default_tags, map()}
  @type base_options :: [base_option()]

  @doc """
  Turns a %Plug.Conn{} with metatags into HTML
  """
  @spec from_conn(Plug.Conn.t(), base_options()) :: HTML.Safe.t()
  def from_conn(%Plug.Conn{private: %{metatags: metatags}}, base_options) when is_list(base_options) do
    Enum.reduce(metatags, [], fn {key, value}, acc ->
      [print_tag(metatags, key, value, base_options) | acc]
    end)
  end

  def from_conn(%Plug.Conn{private: %{metatags: metatags}} = conn) do
    default_options = [
      sitename: Application.get_env(:metatags, :sitename),
      separator: Application.get_env(:metatags, :separator),
      default_tags: Application.get_env(:metatags, :default_tags),
    ]

    from_conn(conn, default_options)
  end

  def from_conn(_) do
    raise ArgumentError,
      message: "No metatags was present in the passed struct. Did you forget to add it?"
  end

  defp print_tag(metatags, prefix, %{} = map, base_options) do
    map
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metatags, "#{prefix}:#{key}", value, base_options) | acc]
    end)
  end

  defp print_tag(_, "title", value, base_options) when is_nil(value) do
    Tag.content_tag(:title, do: Keyword.get(base_options, :sitename))
  end

  defp print_tag(_, "title", value, base_options) do
    sitename = Keyword.get(base_options, :sitename)
    separator = Keyword.get(base_options, :separator, "-")

    suffix = if sitename, do: [separator, sitename], else: []

    Tag.content_tag(:title, do: Enum.join([value] ++ suffix, " "))
  end

  defp print_tag(metatags, "keywords" = key, value, base_options) when is_list(value) do
    print_tag(metatags, key, Enum.join(value, ", "), base_options)
  end

  defp print_tag(_, key, value, _) do
    Tag.tag(:meta, name: key, content: value)
  end
end
