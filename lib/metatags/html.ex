defmodule Metatags.HTML do
  @moduledoc """
  Transforms metatags to HTML
  """

  alias Metatags.HTML.TagBuilder
  alias Plug.Conn

  @doc """
  Turns a `%Plug.Conn{}` with metatags into HTML
  """
  @spec from_conn(Conn.t()) :: Phoenix.HTML.safe()
  def from_conn(%Conn{private: %{metatags: metatags}} = conn) do
    {metatags, config} = Map.pop(metatags, :metatags)

    metatags
    |> set_missing_canonical(fn -> request_url(conn) end)
    |> Enum.reduce([], fn {key, value}, acc ->
      [TagBuilder.print_tag(metatags, key, value, config) | acc]
    end)
  end

  def from_conn(_) do
    raise ArgumentError,
      message:
        "No metatags was present in the passed struct. Did you forget to add it?"
  end

  defp set_missing_canonical(%{"canonical" => _} = metatags, _func) do
    metatags
  end

  defp set_missing_canonical(metatags, func) do
    Map.put(metatags, "canonical", func.())
  end

  defp request_url(conn) do
    Conn.request_url(%Conn{conn | query_string: ""})
  end
end
