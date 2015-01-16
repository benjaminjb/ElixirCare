defmodule Elixirtask.User do
  
  defstruct email: "", name: "", pword: "", active: true #, tasks: []

  def start_link do
    db = Application.get_env(:elixirtask_users, :users_data)
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
  end

  def get(key) do
    :cberl.get(pool, key) |> elem(2)
  end

  def mget(keys) do
    :cberl.mget(pool, keys) |> Enum.map(&elem(&1, 2))
  end

  def get_all do
    view = Application.get_env(:elixirtask_all_users, :view)

    :cberl.view(
      view[:poolname],
      view[:docname] |> String.to_char_list,
      view[:viewname] |> String.to_char_list,
      []
    )
  end

  def signup(args) do
    {:ok, {_, users}} = Elixirtask.User.get_all

    users = users
    |> Enum.map(&List.keyfind(&1, "key", 0))
    
    cond do 
      Enum.any?(users, &(Kernel.==&1,{"key", [args[:email], true]})) 
        -> :error
      Enum.any?(users, &(Kernel.==&1,{"key", [args[:email], false]}))
        -> {:error, :reactivate}
      true -> create(args)
    end
  end

  defp create(args) do
    %Elixirtask.User{}
    |> Map.merge(args)
    |> set
  end

  def deactivate_account(key), do: update(key, %{active: false})

  def activate_account(key), do: update(key, %{active: true})

  def update(key, map_update) do
    get(key) 
    |> Map.merge(map_update) 
    |> set
  end

  defp set(args) do
    %{email: email} = args

    :cberl.set(
      pool, 
      email |> String.to_char_list, 
      0, 
      args)
  end

  defp pool do
    db = Application.get_env(:elixirtask_users, :users_data)
    db[:poolname]
  end
end