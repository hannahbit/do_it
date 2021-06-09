defmodule DoItWeb.ListController do
  use DoItWeb, :controller
  alias DoIt.List
  alias DoIt.Repo

  def show(conn, %{"id" => id}) do
    case Repo.get(List, id) do
      list = %List{} ->
        conn
        |> put_status(200)
        |> render("show.json", list: list)

      nil ->
        conn
        |> put_status(404)
        |> put_view(DoItWeb.ErrorView)
        |> render("404.json")
    end
  end

  def create(conn, params) do
    result =
      params
      |> List.create_changeset()
      |> Repo.insert()

    case result do
      {:ok, list} ->
        conn
        |> put_status(200)
        |> render("show.json", list: list)

      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_view(DoItWeb.ErrorView)
        |> render("error.json", changeset: changeset)
    end
  end
end
