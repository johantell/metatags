defmodule Metatags.Plug do
  @moduledoc """
  `Metatags.Plug` is a plug that can be used in a Plug router
  """

  alias Metatags.Config
  alias Plug.Conn

  @behaviour Plug

  @assign_key :__metatags__

  @doc false
  def init(options) do
    Config.build(options)
  end

  @doc false
  def call(conn, defaults) do
    Conn.assign(conn, @assign_key, defaults)
  end
end
