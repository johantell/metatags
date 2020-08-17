defmodule Metatags do
  @moduledoc """
    Metatags is used to provide an easy API to print out context-specific
    metatags.
  """

  alias Metatags.HTML
  alias Plug.Conn

  @type metatag_value ::
          String.t() | [String.t()] | {String.t(), Keyword.t()} | map() | nil

  @doc """
    Puts a key and a value in the on a %Conn{} struct

    example:

    ```
    iex> conn = %Conn{}
    iex> Metatags.put(conn, "title", "Welcome!")
    %Conn{private: %{metadata: %{"title" => "Welcome!"}}}
    ```
  """
  @spec put(Conn.t(), atom, metatag_value()) :: struct
  def put(conn, key, value) when is_atom(key) do
    put(conn, Atom.to_string(key), value)
  end

  @spec put(Conn.t(), String.t(), metatag_value()) :: struct
  def put(%Conn{private: %{metatags: metatags}} = conn, key, value) do
    {_, metatags} =
      Map.get_and_update(metatags, :metatags, fn metadata ->
        {metadata, Map.put(metadata, key, value)}
      end)

    Conn.put_private(conn, :metatags, metatags)
  end

  @spec put(Conn.t(), String.t(), metatag_value, Keyword.t()) :: struct
  def put(conn, key, value, extra_attributes) do
    put(conn, key, {value, extra_attributes})
  end

  @doc """
    Turns metadata information into HTML tags
  """
  @spec print_tags(Conn.t()) :: Phoenix.HTML.safe()
  def print_tags(%Conn{} = conn) do
    HTML.from_conn(conn)
  end
end
