defmodule DoItWeb.ListController do
  use DoItWeb, :controller
  alias DoIt.Repo
  action_fallback DoItWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, list} <- Repo.get_list(id) do
      display_list(conn, list)
    end
  end

  def create(conn, params) do
    with {:ok, list} <- Repo.create_list(params) do
      display_list(conn, list)
    end
  end

  def update(conn, %{"id" => id, "title" => title}) do
    with {:ok, list} <- Repo.get_list(id),
         {:ok, updated_list} <- Repo.update_list(list, title) do
      display_list(conn, updated_list)
    end
  end

  def update(conn, %{"id" => id}) do
    update(conn, %{"id" => id, "title" => nil})
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, list} <- Repo.get_list(id),
         {:ok, _list} <- Repo.delete(list) do
      send_resp(conn, :no_content, "")
    end
  end

  defp display_list(conn, list) do
    list = Repo.preload(list, :todos)

    conn
    |> put_status(200)
    |> render("show.json", list: list)
  end
end
