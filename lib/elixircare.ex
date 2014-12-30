############################################
# Basic Plug

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

############################################
# Basic Plug.Router
# with match / dispatch
# with params from url
# with guard clause
# with catch all for error

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

############################################
# simple Blaguth authentication experiment

# defmodule CavePlug do
#   import Plug.Conn
#   use Plug.Builder

#   plug Blaguth, realm: "Secret",
#     credentials: {"Ali Baba", "Open Sesame"}

#   plug :index

#   def index(conn, _opts) do
#     send_resp(conn, 200, "Hello Ali Baba")
#   end
# end

############################################
# more complex Blaguth authentication experiment

# defmodule CavePlug do
#   import Plug.Conn
#   use Plug.Router

#   plug Blaguth

#   plug :match
#   plug :dispatch

#   get "/" do
#     send_resp(conn, 200, "Everyone can see me!")
#   end

#   get "/secret" do
#     if authenticated?(conn.assigns) do
#       send_resp(conn, 200, "I'm only accessible if you know the password")
#     else
#       Blaguth.halt_with_login(conn, "Secret")
#     end
#   end

#   defp authenticated?(%{credentials: {user, pass}}) do
#     User.authenticate(user, pass)
#   end
# end

# Plug.Adapters.Cowboy.http CavePlug, []

# ERROR: not working

############################################
# PlugBasicAuth, basic implementation

# defmodule TopSecret do
#   import Plug.Conn
#   use Plug.Router

# # This doesn't work the way I want it to
#   get "/test" do
#     conn
#     |> put_resp_content_type("text/plain")
#     |> send_resp(200, "Hello, Newman, for everyone!")
#   end

#   plug PlugBasicAuth, username: "Name", password: "PW"
#   plug :match
#   plug :dispatch

#   get "/top_secret" do
#     conn
#     |> put_resp_content_type("text/plain")
#     |> send_resp(200, "Hello, Newman.")
#   end
# end

# Plug.Adapters.Cowboy.http TopSecret, []