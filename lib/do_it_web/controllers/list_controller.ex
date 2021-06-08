defmodule DoItWeb.ListController do
  use DoItWeb, :controller

  def create(conn, _params) do
    list = %{title: "test"}

    render(conn, "show.json", list: list)
  end

end
