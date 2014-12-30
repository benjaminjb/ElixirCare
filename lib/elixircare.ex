defmodule Elixircare do
end

defmodule MyPlug do
  import Plug.Conn

  def init(options) do
    # initialize options

    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

Plug.Adapters.Cowboy.http MyPlug, []
IO.puts "Running MyPlug with Cowboy on http://localhost:4000"