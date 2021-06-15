defmodule DoItWeb.TodoController do
  use DoItWeb, :controller
  alias DoIt.Repo
  action_fallback DoItWeb.FallbackController

  def check_done(conn, %{"id" => id}) do
    with {:ok, todo} <- Repo.get_todo(id) do
      conn
      |> put_status(200)
      |> put_view(DoItWeb.ListView)
      |> render("todo.json", todo: todo)
    end
  end
end
