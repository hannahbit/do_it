defmodule DoItWeb.ListView do
  use DoItWeb, :view

  def render("show.json", %{list: list}) do
    %{data: render_one(list, DoItWeb.ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{title: list.title}
  end

  def render("error.json", %{changeset: changeset}) do

    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

    %{errors: errors}
  end
end
