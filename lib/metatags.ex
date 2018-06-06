defmodule Metatags do
  @moduledoc """
    Metatags is used to provide an easy api to print out context-specific
    metatags.
  """
  alias Phoenix.HTML.Tag

  @sitename Application.get_env(:metatags, :sitename)
  @default_meta_tags Application.get_env(:metatags, :default_tags, %{})
  @separator Application.get_env(:metatags, :separator, "-")

  @doc false
  def init(_opts), do: nil

  @doc false
  def call(conn, _opts) do
    conn
    |> Map.put(:metadata, @default_meta_tags)
  end

  @doc """
    Puts a key and a value in the metadata store

    example:

    ```
    iex> %{metadata: %{}} |> Metatags.put("title", "Welcome!")
    %{metadata: %{"title" => "Welcome!"}}
    ```
  """
  @spec put(map, atom, String.t | map) :: struct
  def put(conn, key, value) when is_atom(key) do
    put(conn, Atom.to_string(key), value)
  end

  @spec put(map, String.t, String.t | map) :: struct
  def put(conn, key, value) do
    metadata =
      conn.metadata
      |> Map.put(key, value)

    conn
    |> Map.put(:metadata, metadata)
  end

  @doc """
    turns metadata information into HTML tags
  """
  @spec print_tags(map) :: Phoenix.HTML.Safe.t
  def print_tags(%{metadata: metadata}) do
    metadata
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metadata, key, value) | acc]
    end)
  end

  def print_tags(_map), do: nil

  defp print_tag(metadata, prefix, %{} = map) do
    map
    |> Enum.reduce([], fn {key, value}, acc ->
      [print_tag(metadata, "#{prefix}:#{key}", value) | acc]
    end)
  end

  defp print_tag(_, "title", value) when is_nil(value),
    do: Tag.content_tag(:title, do: @sitename)

  defp print_tag(metadata, key, value) when is_atom(key) do
    print_tag(metadata, Atom.to_string(key), value)
  end

  defp print_tag(_, "title", value) do
    suffix = if @sitename, do: [@separator, @sitename], else: []

    Tag.content_tag(:title, do: Enum.join([value] ++ suffix, " "))
  end

  defp print_tag(metadata, "keywords" = key, value) when is_list(value) do
    print_tag(metadata, key, Enum.join(value, ", "))
  end

  defp print_tag(metadata, "og:title" = key, value) do
    Tag.tag(:meta, name: key, content: value || metadata["title"])
  end

  defp print_tag(metadata, "og:url" = key, value) do
    Tag.tag(
      :meta,
      name: key,
      content: value || Map.get(metadata, "canonical", nil)
    )
  end

  defp print_tag(_, key, value), do: Tag.tag(:meta, name: key, content: value)
end
