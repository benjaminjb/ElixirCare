defmodule Elixirtask.Couchbase do
  alias Elixirtask.Config

  def start_link do
    db = Config.get(:database)

    :cberl.start_link(
      db[:poolname],
      db[:poolsize],
      db[:host] |> String.to_char_list,
      db[:username] |> String.to_char_list,
      db[:password] |> String.to_char_list,
      db[:bucket] |> String.to_char_list,
      Elixirtask.Transcoder
    )
  end

  def get(key) do
    :cberl.get(pool, key)
  end

  def mget(keys) do
    :cberl.mget(pool, keys)
  end

  defp pool do
    Config.get(:database)[:poolname]
  end
end