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

    {:ok, users_db: users_db}
  end

  test "can get a list of all users (when there are none)" do
    test = Elixirtask.User.get_all
    assert test == {:ok, {0, []}}
  end

  test "can signup and get a user" do
    Elixirtask.User.signup(%{email: "test1", name: "test_name1", pword: "test_pword1"})
    test = Elixirtask.User.get("test1")
    assert test == %{email: "test1", name: "test_name1", pword: "test_pword1", active: true}
  end

  test "can signup and get multiple named users" do
    Elixirtask.User.signup(%{email: "test2", name: "test_name2", pword: "test_pword2"})
    test = Elixirtask.User.mget(["test1", "test2"])
    assert test == [%{email: "test1", name: "test_name1", pword: "test_pword1", active: true}, %{email: "test2", name: "test_name2", pword: "test_pword2", active: true}]
  end

  test "can get all users with a view" do
    test = Elixirtask.User.get_all
    assert test == {:ok, {2, [[{"id", "test1"}, {"key", ["test1", true]}, {"value", :null}], [{"id", "test2"}, {"key", ["test2", true]}, {"value", :null}]]}}
  end

  test "can deactivate a user" do 
    Elixirtask.User.deactivate_account("test2")
    test = Elixirtask.User.get("test2")
    assert test == %{email: "test2", name: "test_name2", pword: "test_pword2", active: false}
  end

  test "only signs up a user with a unique email" do
    res = Elixirtask.User.signup(%{email: "test1", name: "error_name", pword: "error_pword"})
    assert res == :error

    test = Elixirtask.User.get("test1")
    assert test == %{email: "test1", name: "test_name1", pword: "test_pword1"}

    {:ok, {count_test, _}} = Elixirtask.User.get_all
    assert count_test == 2
  end

  test "gives alternate error when attempt to signup with email already entered but associated with deactivated account" do
    res = Elixirtask.User.signup(%{email: "test2", name: "error_name_reactivate", pword: "error_pword_reactivate"})
    assert res == {:error, :reactivate}
  
    test = Elixirtask.User.get("test2")
    assert test == %{email: "test2", name: "test_name2", pword: "test_pword2", active: false}

    {:ok, {count_test, _}} = Elixirtask.User.get_all
    assert count_test == 2
  end

  test "can reactivate a user" do 
    Elixirtask.User.activate_account("test2")
    test = Elixirtask.User.get("test2")
    assert test == %{email: "test2", name: "test_name2", pword: "test_pword2", active: true}
  end

end