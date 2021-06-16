defmodule DoItWeb.TodoControllerTest do
  use DoItWeb.ConnCase
  alias DoIt.Repo
  alias DoIt.Todo

  @valid_description %{description: "Wash dishes"}
  @invalid_description %{description: ""}
  @valid_update_params %{description: "Wash dishes", done: true}

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

    test "saves todo and redirects to ListController#show when data valid and list exists", %{
      conn: conn
    } do
      list = insert(:list)
      path = Routes.list_todo_path(conn, :create, list.id)
      conn = post(conn, path, @valid_description)
      todos = DoIt.Repo.preload(list, :todos).todos
      assert List.last(todos).description == @valid_description.description
      assert redirected_to(conn) =~ "/api/list/#{list.id}"
    end
  end

  describe "update" do
    test "renders 404 when todo does not exist", %{conn: conn} do
      conn = patch(conn, Routes.todo_path(conn, :update, 123))
      assert response(conn, 404)
    end

    test "renders 400 if updated description is invalid", %{conn: conn} do
      todo = insert(:todo)
      conn = patch(conn, Routes.todo_path(conn, :update, todo.id), @invalid_description)
      assert response(conn, 400)
    end

    test "renders 200 and shows updated todo if params are valid", %{conn: conn} do
      todo = insert(:todo)
      conn = patch(conn, Routes.todo_path(conn, :update, todo.id), @valid_update_params)

      assert json_response(conn, 200) == %{
               "done" => @valid_update_params.done,
               "description" => @valid_update_params.description,
               "id" => todo.id
             }
    end
  end

  describe "check_done" do
    test "renders 404 if there is no todo with that id", %{conn: conn} do
      conn = patch(conn, Routes.todo_path(conn, :check_done, 123))
      assert response(conn, 404)
    end

    test "renders 200 and checked todo if there is a todo with that id", %{conn: conn} do
      todo = insert(:todo)
      conn = patch(conn, Routes.todo_path(conn, :check_done, todo.id))

      assert json_response(conn, 200) == %{
               "done" => true,
               "description" => todo.description,
               "id" => todo.id
             }
    end
  end

  describe "delete" do
    test "renders 404 if todo does not exist", %{conn: conn} do
      todo_count = Repo.aggregate(Todo, :count)
      conn = delete(conn, Routes.todo_path(conn, :delete, 123))
      assert response(conn, 404)
      assert Repo.aggregate(Todo, :count) == todo_count
    end

    test "renders 204 if todo exists and is successfully deleted", %{conn: conn} do
      todo = insert(:todo)
      todo_count = Repo.aggregate(Todo, :count)
      conn = delete(conn, Routes.todo_path(conn, :delete, todo.id))
      assert response(conn, 204)
      assert Repo.aggregate(Todo, :count) == todo_count - 1
    end
  end
end
