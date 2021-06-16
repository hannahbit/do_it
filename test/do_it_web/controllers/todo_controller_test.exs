defmodule DoItWeb.TodoControllerTest do
  use DoItWeb.ConnCase
  alias DoIt.Repo
  alias DoIt.Todo

  @valid_description %{description: "Wash dishes"}
  @invalid_description %{description: ""}
  @valid_update_params %{description: "Wash dishes", done: true}

  defp insert_list(_context) do
    %{list: insert(:list)}
  end

  defp get_create_list_path(%{list: list, conn: conn}) do
    %{path: Routes.list_todo_path(conn, :create, list.id)}
  end

  defp insert_todo(_context) do
    %{todo: insert(:todo)}
  end

  defp count_todos(_context) do
    %{todo_count: Repo.aggregate(Todo, :count)}
  end

  describe "create" do
    setup [:insert_list, :get_create_list_path]

    test "renders 404 when list does not exist", %{conn: conn} do
      path = Routes.list_todo_path(conn, :create, 461_212)
      conn = post(conn, path, @valid_description)
      assert response(conn, 404)
    end

    test "renders 400 if invalid data given", %{conn: conn, path: path} do
      conn = post(conn, path, @invalid_description)
      assert response(conn, 400)
    end

    test "saves todo and redirects to ListController#show when data valid and list exists", %{
      conn: conn,
      list: list,
      path: path
    } do
      conn = post(conn, path, @valid_description)
      todos = DoIt.Repo.preload(list, :todos).todos
      assert List.last(todos).description == @valid_description.description
      assert redirected_to(conn) =~ "/api/list/#{list.id}"
    end
  end

  describe "update" do
    setup :insert_todo

    test "renders 404 when todo does not exist", %{conn: conn} do
      conn = patch(conn, Routes.todo_path(conn, :update, 123))
      assert response(conn, 404)
    end

    test "renders 400 if updated description is invalid", %{conn: conn, todo: todo} do
      conn = patch(conn, Routes.todo_path(conn, :update, todo.id), @invalid_description)
      assert response(conn, 400)
    end

    test "renders 200 and shows updated todo if params are valid", %{conn: conn, todo: todo} do
      conn = patch(conn, Routes.todo_path(conn, :update, todo.id), @valid_update_params)

      assert json_response(conn, 200) == %{
               "done" => @valid_update_params.done,
               "description" => @valid_update_params.description,
               "id" => todo.id
             }
    end
  end

  describe "check_done" do
    setup :insert_todo

    test "renders 404 if there is no todo with that id", %{conn: conn} do
      conn = patch(conn, Routes.todo_path(conn, :check_done, 123))
      assert response(conn, 404)
    end

    test "renders 200 and checked todo if there is a todo with that id", %{conn: conn, todo: todo} do
      conn = patch(conn, Routes.todo_path(conn, :check_done, todo.id))

      assert json_response(conn, 200) == %{
               "done" => true,
               "description" => todo.description,
               "id" => todo.id
             }
    end
  end

  describe "delete" do
    setup [:insert_todo, :count_todos]

    test "renders 404 if todo does not exist", %{conn: conn, todo_count: todo_count} do
      conn = delete(conn, Routes.todo_path(conn, :delete, 123))
      assert response(conn, 404)
      assert Repo.aggregate(Todo, :count) == todo_count
    end

    test "renders 204 if todo exists and is successfully deleted", %{
      conn: conn,
      todo: todo,
      todo_count: todo_count
    } do
      conn = delete(conn, Routes.todo_path(conn, :delete, todo.id))
      assert response(conn, 204)
      assert Repo.aggregate(Todo, :count) == todo_count - 1
    end
  end
end
