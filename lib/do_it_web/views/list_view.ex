defmodule DoItWeb.ListView do
  use DoItWeb, :view

  def render("show.json", %{list: list}) do
    %{data: render_one(list, DoItWeb.ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{title: list.title}
  end
end
