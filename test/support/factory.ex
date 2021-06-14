defmodule DoIt.Factory do
  use ExMachina.Ecto, repo: DoIt.Repo
  alias DoIt.List
  alias DoIt.Todo

  def list_factory do
    %List{
      title: "My Todo List"
    }
  end

  def todo_factory do
    %Todo{
      description: "Water Plants",
      list: build(:list)
    }
  end
end
