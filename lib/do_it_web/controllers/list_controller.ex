defmodule DoItWeb.ListController do
  use DoItWeb, :controller

  def show(conn, _params) do
    list = %{title: "Foo"}

    render(conn, "show.json", list: list)
  end

  def create(conn, _params) do
    list = %{title: "test"}

    render(conn, "show.json", list: list)
  end
end
