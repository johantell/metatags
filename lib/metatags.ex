defmodule Metatags do
  @moduledoc """
  Metatags is used to provide an easy API to print out context-specific
  metatags.
  """

  alias Metatags.Config
  alias Metatags.HTML
  alias Metatags.Transport

  @type metatag_value ::
          String.t() | [String.t()] | {String.t(), Keyword.t()} | map() | nil

  @doc """
  Puts a key and a value in the on a the a struct adhering to the
  `Metatags.Transport` protocol.

  ## Example:

    iex> conn = %Conn{}
    iex> Metatags.put(conn, "title", "Welcome!")
    %Conn{private: %{metadata: %{"title" => "Welcome!"}}}

  """
  @spec put(struct(), String.t() | atom(), metatag_value()) :: struct
  def put(transport, key, value) do
    Transport.put(transport, key, value)
  end

  @spec put(struct(), String.t() | atom(), metatag_value(), Keyword.t()) ::
          struct()
  def put(conn, key, value, extra_attributes) do
    put(conn, key, {value, extra_attributes})
  end

  @doc """
  Turns metadata information into HTML tags
  """
  @spec print_tags(struct()) :: Phoenix.HTML.safe()
  def print_tags(transport) do
    transport
    |> Transport.get_metatags()
    |> add_missing_canonical(transport)
    |> HTML.from_metatags()
  end

  defp add_missing_canonical(metatags, transport) do
    if Map.has_key?(metatags.metatags, "canonical") do
      metatags
    else
      canonical_url = Transport.canonical_url(transport)

      Config.put_meta(metatags, "canonical", canonical_url)
    end
  end
end
