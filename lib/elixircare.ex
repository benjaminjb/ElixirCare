# defmodule Elixircare do
# end

# defmodule MyPlug do
#   import Plug.Conn

#   def init(options) do
#     # initialize options

#     options
#   end

#   def call(conn, _opts) do
#     conn
#     |> put_resp_content_type("text/plain")
#     |> send_resp(200, "Hello world and goodbye")
#   end
# end

# defmodule AppRouter do
#   use Plug.Router

#   plug :match
#   plug :dispatch

#   get "/hello" do
#     send_resp(conn, 200, "world")
#   end

#   get "/hello/:name" do
#     send_resp(conn, 200, "hello #{name}")
#   end

#   match "/helloo/:bar" when byte_size(bar) <= 3, via: :get do
#     send_resp(conn, 200, "hello world, your bar is #{bar}")
#   end

#   match _ do
#     send_resp(conn, 404, "oops")
#   end
# end

# Plug.Adapters.Cowboy.http AppRouter, []
# IO.puts "Running MyPlug with Cowboy on http://localhost:4000"

defmodule CavePlug do
  import Plug.Conn
  use Plug.Builder

  plug Blaguth, realm: "Secret",
    credentials: {"Ali Baba", "Open Sesame"}

  plug :index

  def index(conn, _opts) do
    send_resp(conn, 200, "Hello Ali Baba")
  end
end

Plug.Adapters.Cowboy.http CavePlug, []