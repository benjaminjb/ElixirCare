defmodule Elixirtask.Task do
  use Timex

  defstruct created_by: "", created_at: "", deadline: "", task: "", done: false, type: "task"

  def start_link do
    db = Application.get_env(:elixirtask_tasks, :tasks_data)
    # {:ok, users_db} = 
    :cberl.start_link(
      db[:poolname],
      db[:poolsize],
      db[:host] |> String.to_char_list,
      db[:username] |> String.to_char_list,
      db[:password] |> String.to_char_list,
      db[:bucket] |> String.to_char_list,
      Elixirtask.Transcoder
    )

    set_key
  end

  def get(key) do
    :cberl.get(pool, key) |> elem(2)
  end

  def mget(keys) do
    :cberl.mget(pool, keys) |> Enum.map(&elem(&1, 2))
  end

  def get_all(options \\ []) do
    view = Application.get_env(:elixirtask_all_tasks, :view)

    :cberl.view(
      view[:poolname],
      view[:docname] |> String.to_char_list,
      view[:viewname] |> String.to_char_list,
      options
    )
  end

  # def signup(args) do
  #   {:ok, {_, users}} = Elixirtask.User.get_all

  #   users = users
  #   |> Enum.map(&List.keyfind(&1, "key", 0))
    
  #   cond do 
  #     Enum.any?(users, &(Kernel.==&1,{"key", [args[:email], true]})) 
  #       -> :error
  #     Enum.any?(users, &(Kernel.==&1,{"key", [args[:email], false]}))
  #       -> {:error, :reactivate}
  #     true -> create(args)
  #   end
  # end

  # defp create(args) do
  #   %Elixirtask.User{}
  #   |> Map.merge(args)
  #   |> set
  # end

  # def deactivate_account(key), do: update(key, %{active: false})

  # def activate_account(key), do: update(key, %{active: true})

  # def update(key, map_update) do
  #   get(key) 
  #   |> Map.merge(map_update) 
  #   |> set
  # end

  defp set(args) do
    :cberl.set(
      pool, 
      key_id |> Integer.to_string, 
      0, 
      args
    )
    increment_key(key_id)
  end

  defp pool do
    db = Application.get_env(:elixirtask_tasks, :tasks_data)
    db[:poolname]
  end

  defp key_id do
    x = :cberl.get(pool, "key_id") |> elem(2) 
    # is there a way to pipe a map to get an access
    x.key
  end

  defp increment_key(key_id) do
    :cberl.set(
      pool, 
      "key_id", 
      0, 
      %{key: key_id + 1}
    )
  end

  defp set_key do
    case :cberl.get(pool, "key_id") do
      {"key_id", {:error, :key_enoent}}
        -> :cberl.set(pool, "key_id", 0, %{key: 0})
      _ -> :ok
    end
  end
  
end