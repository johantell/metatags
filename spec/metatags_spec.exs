defmodule MetatagsSpec do
  use ESpec, async: true
  use Plug.Test

  describe "init" do
    it "returns nil" do
      expect(Metatags.init([])).to eq(nil)
    end
  end

  describe "call" do
    it "sets the default metatags" do
      conn =
        conn(:get, "/")
        |> Metatags.call([])

      expect(conn.private.metatags).to eq(%{})
    end
  end

  describe "put" do
    it "puts the passed metatag data into the %Plug.Conn{}" do
      conn =
        build_conn()
        |> Metatags.put("title", "my title")

      expect(conn.private.metatags).to eq(%{"title" => "my title"})
    end

    it "allows atoms as keys" do
      conn =
        build_conn()
        |> Metatags.put(:title, "my title")

      expect(conn.private.metatags).to eq(%{"title" => "my title"})
    end
  end

  describe "print_tags" do
    it "calls Metatags.HTML.from_conn" do
      conn = build_conn()
      allow(Metatags.HTML).to accept(:from_conn)

      Metatags.print_tags(conn)

      expect(Metatags.HTML).to accepted(:from_conn)
    end
  end

  defp build_conn do
    conn(:get, "/")
    |> Metatags.call([])
  end
end
