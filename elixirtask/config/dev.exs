use Mix.Config

config :tasks, port: 4000

config :elixirtask_users, :users_data,
  poolname: :users_db,
  poolsize: 5,
  host: "localhost:8091",
  username: "ex-task-users",
  password: "",
  bucket: "ex-task-users"

config :elixirtask_all_users, :view,
  poolname: :users_db,
  docname: "dev_users",
  viewname: "all_users",
  endpoint: "http://localhost:8092/ex-task-users/_design/dev_users/_view/all_users"

config :elixirtask_tasks, :users_data,
  poolname: :tasks_db,
  poolsize: 5,
  host: "localhost:8091",
  username: "ex-task-tasks",
  password: "",
  bucket: "ex-task-tasks"

config :elixirtask_all_tasks, :view,
  poolname: :tasks_db,
  docname: "dev_tasks",
  viewname: "all_tasks",
  endpoint: "http://localhost:8092/ex-task-tasks/_design/dev_tasks/_view/all_tasks"

