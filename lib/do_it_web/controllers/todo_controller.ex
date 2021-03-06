defmodule DoItWeb.TodoController do
  use DoItWeb, :controller
  alias DoIt.Repo
  action_fallback DoItWeb.FallbackController

  def create(conn, params) do
    with {:ok, todo} <- Repo.create_todo(params) do
      redirect(conn, to: Routes.list_path(conn, :show, todo.list_id))
    end
  end

  def update(conn, params) do
    with {:ok, todo} <- Repo.get_todo(params["id"]),
         {:ok, todo} <- Repo.update_todo(todo, params) do
      render_todo(conn, todo)
    end
  end

  def check_done(conn, %{"id" => id}) do
    with {:ok, todo} <- Repo.get_todo(id),
         {:ok, todo} <- Repo.check_done(todo) do
      render_todo(conn, todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, todo} <- Repo.get_todo(id),
         {:ok, _todo} <- Repo.delete(todo) do
      send_resp(conn, :no_content, "")
    end
  end

  defp render_todo(conn, todo) do
    conn
    |> put_status(200)
    |> put_view(DoItWeb.ListView)
    |> render("todo.json", todo: todo)
  end
end
