defmodule DoItWeb.TodoController do
  use DoItWeb, :controller
  alias DoIt.Repo
  action_fallback DoItWeb.FallbackController

  def create(conn, params) do
    with {:ok, todo} <- Repo.create_todo(params) do
      redirect(conn, to: Routes.list_path(conn, :show, todo.list_id))
    end
  end
end
