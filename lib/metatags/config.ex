defmodule Metatags.Config do
  @moduledoc false

  defstruct sitename: nil, title_separator: "-", metatags: %{}

  @type t :: %__MODULE__{
          sitename: nil | String.t(),
          title_separator: String.t(),
          metatags: %{}
        }
end
