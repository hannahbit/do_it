defmodule DoItWeb.ListView do
  use DoItWeb, :view

  def render("show.json", %{list: list}) do
    %{data: render_one(list, DoItWeb.ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{
      id: list.id,
      title: list.title,
      todos: render_many(list.todos, DoItWeb.ListView, "todo.json", as: :todo)
    }
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      description: todo.description,
      done: todo.done
    }
  end
end
