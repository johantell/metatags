defmodule Metatags.Config do
  @moduledoc false

  defstruct sitename: nil, title_separator: "-", metatags: %{}

  @type t :: %__MODULE__{
          sitename: nil | String.t(),
          title_separator: String.t(),
          metatags: %{}
        }

  @spec put_meta(t(), String.t() | atom(), any()) :: t()
  def put_meta(%__MODULE__{} = config, key, value) do
    put_in(config, [Access.key!(:metatags), to_string(key)], value)
  end
end
