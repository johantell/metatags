defmodule Metatags.Transport.MapTest do
  use ExUnit.Case, async: true

  describe "get_metatags/1" do
    test "returns the metatags" do
      config = %Metatags.Config{}
      map = %{__metatags__: config}

      assert config == Metatags.Transport.get_metatags(map)
    end
  end

  describe "put/4" do
    test "raises with a message" do
      assert_raise RuntimeError, fn ->
        Metatags.Transport.put(%{}, :key, :value)
      end
    end
  end

  describe "init/4" do
    test "raises with a message" do
      assert_raise RuntimeError, fn ->
        Metatags.Transport.init(%{}, [])
      end
    end
  end
end
