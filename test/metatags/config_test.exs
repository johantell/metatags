defmodule Metatags.ConfigTest do
  use ExUnit.Case, async: true

  alias Metatags.Config

  describe "defstruct/1" do
    test "defines a structure with defaults" do
      assert %Config{sitename: nil, title_separator: "-", metatags: %{}} =
               %Config{}
    end
  end
end
