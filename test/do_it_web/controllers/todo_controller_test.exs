defmodule DoItWeb.TodoControllerTest do
  use DoItWeb.ConnCase

  @valid_description %{description: "Wash dishes"}
  @invalid_description %{description: ""}

  describe "create" do
    test "renders 404 when list does not exist", %{conn: conn} do
      path = Routes.list_todo_path(conn, :create, 461_212)
      conn = post(conn, path, @valid_description)
      assert response(conn, 404)
    end

    test "renders 400 if invalid data given", %{conn: conn} do
      list = insert(:list)
      path = Routes.list_todo_path(conn, :create, list.id)
      conn = post(conn, path, @invalid_description)
      assert response(conn, 400)
    end

    test "saves todo and redirects to ListController#show when data valid and list exists", %{conn: conn} do
      list = insert(:list)
      path = Routes.list_todo_path(conn, :create, list.id)
      conn = post(conn, path, @valid_description)
      todos = DoIt.Repo.preload(list, :todos).todos
      assert Elixir.List.last(todos).description == @valid_description.description
      assert redirected_to(conn) =~ "/api/list/#{list.id}"
    end
  end
end
