defmodule Metatags do
  @moduledoc """
    Metatags is used to provide an easy api to print out context-specific
    metatags.
  """

  alias Metatags.HTML
  alias Plug.Conn

  @default_meta_tags Application.get_env(:metatags, :default_tags, %{})

  @doc false
  def init(_opts), do: nil

  @doc false
  def call(conn, _opts) do
    conn
    |> Conn.put_private(:metatags, @default_meta_tags)
  end

  @doc """
    Puts a key and a value in the on a %Conn{} struct

    example:

    ```
    iex> conn = %Conn{}
    iex> Metatags.put(conn, "title", "Welcome!")
    %Conn{private: %{metadata: %{"title" => "Welcome!"}}}
    ```
  """
  @spec put(Conn.t(), atom, String.t() | map) :: struct
  def put(conn, key, value) when is_atom(key) do
    put(conn, Atom.to_string(key), value)
  end

  @spec put(Conn.t(), String.t(), String.t() | map) :: struct
  def put(%Conn{private: %{metatags: metatags}} = conn, key, value) do
    metatags =
      metatags
      |> Map.put(key, value)

    conn
    |> Conn.put_private(:metatags, metatags)
  end

  @doc """
    Turns metadata information into HTML tags
  """
  @spec print_tags(Conn.t()) :: Phoenix.HTML.Safe.t()
  def print_tags(%Conn{} = conn) do
    HTML.from_conn(conn)
  end
end
