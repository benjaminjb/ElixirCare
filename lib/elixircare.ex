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
    |> send_resp(200, "Hello world and goodbye")
  end
end

defmodule AppRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end


Plug.Adapters.Cowboy.http AppRouter, []
IO.puts "Running MyPlug with Cowboy on http://localhost:4000"