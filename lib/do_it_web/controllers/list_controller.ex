defmodule DoItWeb.ListController do
  use DoItWeb, :controller

  # def show(conn, %{"id" => id}) do
  #   case Ecto.Repo.get(List, id) do
  #     {:ok, list}         -> conn
  #                             |> put_status(200)
  #                             |> render("show.json", list: list)
  #     {:error, changeset} -> conn
  #                             |> put_status(400)
  #                             |> render("error.json", changeset: changeset)
  #   end
  # end

  def create(conn, _params) do
    list = %{title: "test"}

    render(conn, "show.json", list: list)
  end
end
