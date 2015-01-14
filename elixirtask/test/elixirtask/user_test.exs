defmodule UserTest do
  use ExUnit.Case, async: false

  setup_all do

    db = Application.get_env(:elixirtask_users, :users_data)
    {:ok, users_db} = :cberl.start_link(
      db[:poolname],
      db[:poolsize],
      db[:host] |> String.to_char_list,
      db[:username] |> String.to_char_list,
      db[:password] |> String.to_char_list,
      db[:bucket] |> String.to_char_list,
      Elixirtask.Transcoder
    )
    :cberl.flush(:users_db, 'ex-task-users')

    # on_exit fn ->
    #   :cberl.flush(:users_db, 'ex-task-users')
    #   Process.exit(users_db, :shutdown)
    # end

    {:ok, users_db: users_db}
  end

  # setup do  
  #   :cberl.flush(:users_db, 'ex-task-users')
  #   :ok
  # end
  
  test "can get a list of all users (when there are none)" do
    test = Elixirtask.User.get_all
    assert test == {:ok, {0, []}}
  end

  test "can signup and get a user" do
    Elixirtask.User.signup(%{email: "test1", name: "test_name1", pword: "test_pword1"})
    test = Elixirtask.User.get("test1")
    assert test == %{email: "test1", name: "test_name1", pword: "test_pword1"}
  end

  test "can signup and get multiple named users" do
    Elixirtask.User.signup(%{email: "test2", name: "test_name2", pword: "test_pword2"})
    test = Elixirtask.User.mget(["test1", "test2"])
    assert test == [%{email: "test1", name: "test_name1", pword: "test_pword1"}, %{email: "test2", name: "test_name2", pword: "test_pword2"}]
  end

  test "can set and get all users" do
    test = Elixirtask.User.get_all
    assert test == {:ok, {2, [[{"id", "test1"}, {"key", "test1"}, {"value", :null}], [{"id", "test2"}, {"key", "test2"}, {"value", :null}]]}}
  end

  test "only signs up a user with a unique email" do
    res = Elixirtask.User.signup(%{email: "test1", name: "error_name", pword: "error_pword"})
    assert res == :error

    test = Elixirtask.User.get("test1")
    assert test == %{email: "test1", name: "test_name1", pword: "test_pword1"}

    {:ok, {count_test, _}} = Elixirtask.User.get_all
    assert count_test == 2
  end

end


