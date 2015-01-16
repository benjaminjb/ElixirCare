defmodule TaskTest do
use ExUnit.Case, async: false

  setup_all do

    db = Application.get_env(:elixirtask_tasks, :tasks_data)
    {:ok, tasks_db} = :cberl.start_link(
      db[:poolname],
      db[:poolsize],
      db[:host] |> String.to_char_list,
      db[:username] |> String.to_char_list,
      db[:password] |> String.to_char_list,
      db[:bucket] |> String.to_char_list,
      Elixirtask.Transcoder
    )
    :cberl.flush(:tasks_db, 'ex-task-users')

    {:ok, tasks_db: tasks_db}
  end

  test "can get a list of all tasks (when there are none)" do
    test = Elixirtask.Task.get_all
    assert test == {:ok, {0, []}}
  end

  test "can create and get a task by user" do
    exp_time = Timex.Date.now
    Elixirtask.Task.create(%{created_by: "test1", created_at: exp_time, task: "test_task1"})
    test = Elixirtask.Task.get("test1")
    assert test == %{created_by: "test1", created_at: exp_time, deadline: "", task: "test_task1", done: false}
  end

  test "can get multiple tasks by user" do
    exp_time = Timex.Date.now
    Elixirtask.Task.create(%{created_by: "test1", created_at: exp_time, task: "test_task2"})
    test = Elixirtask.Task.get("test1")
    assert test == [%{created_by: "test1", created_at: exp_time, deadline: "", task: "test_task1", done: false}, %{created_by: "test1", created_at: exp_time, deadline: "", task: "test_task2", done: false}]
  end

  # test "can signup and get multiple named tasks" do
  #   Elixirtask.Task.signup(%{created_by: "test2", task: "test_task2", pword: "test_pword2"})
  #   test = Elixirtask.Task.mget(["test1", "test2"])
  #   assert test == [%{created_by: "test1", task: "test_task1", pword: "test_pword1", active: true}, %{created_by: "test2", task: "test_task2", pword: "test_pword2", active: true}]
  # end

  # test "can get all Tasks with a view" do
  #   test = Elixirtask.Task.get_all
  #   assert test == {:ok, {2, [[{"id", "test1"}, {"key", ["test1", true]}, {"value", :null}], [{"id", "test2"}, {"key", ["test2", true]}, {"value", :null}]]}}
  # end

  # test "can deactivate a Task" do 
  #   Elixirtask.Task.deactivate_account("test2")
  #   test = Elixirtask.Task.get("test2")
  #   assert test == %{created_by: "test2", task: "test_task2", pword: "test_pword2", active: false}
  # end

  # test "only signs up a Task with a unique created_by" do
  #   res = Elixirtask.Task.signup(%{created_by: "test1", task: "error_task", pword: "error_pword"})
  #   assert res == :error

  #   test = Elixirtask.Task.get("test1")
  #   assert test == %{created_by: "test1", task: "test_task1", pword: "test_pword1"}

  #   {:ok, {count_test, _}} = Elixirtask.Task.get_all
  #   assert count_test == 2
  # end

  # test "gives alternate error when attempt to signup with created_by already entered but associated with deactivated account" do
  #   res = Elixirtask.Task.signup(%{created_by: "test2", task: "error_task_reactivate", pword: "error_pword_reactivate"})
  #   assert res == {:error, :reactivate}
  
  #   test = Elixirtask.Task.get("test2")
  #   assert test == %{created_by: "test2", task: "test_task2", pword: "test_pword2", active: false}

  #   {:ok, {count_test, _}} = Elixirtask.Task.get_all
  #   assert count_test == 2
  # end

  # test "can reactivate a Task" do 
  #   Elixirtask.Task.activate_account("test2")
  #   test = Elixirtask.Task.get("test2")
  #   assert test == %{created_by: "test2", task: "test_task2", pword: "test_pword2", active: true}
  # end



end