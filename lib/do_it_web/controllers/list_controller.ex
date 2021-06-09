defmodule DoItWeb.ListController do
  use DoItWeb, :controller
  alias DoIt.List
  alias DoIt.Repo

  def show(conn, _params) do
    list = %{title: "Foo"}

    render(conn, "show.json", list: list)
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
        |> render("error.json", changeset: changeset)
    end
  end
end
