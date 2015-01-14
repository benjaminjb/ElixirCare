defmodule Elixirtask.Config do
  def get do
    Application.get_all_env(:tasks)
  end

  def get(key, default \\ nil) do
    Application.get_env(:tasks, key, default)
  end
end