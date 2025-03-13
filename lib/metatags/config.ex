defmodule Metatags.Config do
  @moduledoc false

  defstruct sitename: nil, title_separator: "-", metatags: %{}

  @type t :: %__MODULE__{
          sitename: nil | String.t(),
          title_separator: String.t(),
          metatags: %{}
        }

  @spec build(Keyword.t()) :: __MODULE__.t()
  def build(options) when is_list(options) do
    default_tags = Keyword.get(options, :default_tags, [])
    sitename = Keyword.get(options, :sitename, nil)
    title_separator = Keyword.get(options, :title_separator, "-")

    default_tags =
      Map.new([{"title", nil} | Enum.to_list(default_tags)], fn {key, value} ->
        {to_string(key), value}
      end)

    %__MODULE__{
      sitename: sitename,
      title_separator: title_separator,
      metatags: default_tags
    }
  end

  @spec put_meta(t(), String.t() | atom(), any()) :: t()
  def put_meta(%__MODULE__{} = config, key, value) do
    put_in(config, [Access.key!(:metatags), to_string(key)], value)
  end
end
