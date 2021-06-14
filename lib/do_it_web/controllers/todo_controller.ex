defmodule DoItWeb.TodoController do
  use DoItWeb, :controller
  alias DoIt.Repo
  action_fallback DoItWeb.FallbackController

  def create(conn, params) do
    with {:ok, todo} <- Repo.create_todo(params) do
      Repo.load_list_with_todos(todo.list_id) |> display_list(conn)
    end
  end

  defp display_list(list, conn) do
      conn
      |> put_status(200)
      |> put_view(DoItWeb.ListView)
      |> render("show.json", list: list)
  end
end
