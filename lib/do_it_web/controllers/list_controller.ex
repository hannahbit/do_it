defmodule DoItWeb.ListController do
  use DoItWeb, :controller
  alias DoIt.Repo
  action_fallback DoItWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, list} <- Repo.get_list(id) do
      conn
      |> put_status(200)
      |> render("show.json", list: list)
    end
  end

  def create(conn, params) do
    with {:ok, list} <- Repo.create_list(params) do
      conn
      |> put_status(200)
      |> render("show.json", list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, list} <- Repo.get_list(id),
         {:ok, _list} <- Repo.delete(list) do
      send_resp(conn, :no_content, "")
    end
  end
end
