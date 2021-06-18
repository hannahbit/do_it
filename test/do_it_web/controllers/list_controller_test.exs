defmodule DoItWeb.ListControllerTest do
  use DoItWeb.ConnCase

  @valid_title params_for(:list)
  @too_short_title %{title: "Go"}

  defp insert_list(_context) do
    %{list: insert(:list)}
  end

  describe "show" do
    setup [:put_authorization, :insert_list]

    test "renders list when list with that id exists", %{conn: conn, list: list} do
      conn = get(conn, Routes.api_list_path(conn, :show, list.id))
      assert json_response(conn, 200)["data"]["title"] == list.title
    end

    test "renders 404 error when list with that id does not exists", %{conn: conn} do
      conn = get(conn, Routes.api_list_path(conn, :show, 123_786_876))
      assert json_response(conn, 404) == "Not Found"
    end
  end

  describe "html request: show" do
    setup :insert_list

    test "renders list when list with that id exists", %{conn: conn, list: list} do
      conn = get(conn, Routes.list_path(conn, :show, list.id))
      list = DoIt.Repo.preload(list, :todos)
      assert html_response(conn, 200) =~ list.title
      for todo <- list.todos do
        assert html_response(conn, 200) =~ todo.description
      end
    end

    test "renders 'Not Found' when list with that id does not exists", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :show, 123_786_876))
      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  describe "create" do
    setup [:put_authorization]

    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_list_path(conn, :create), @valid_title)
      assert json_response(conn, 200)["data"]["title"] == @valid_title.title
    end

    test "renders error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_list_path(conn, :create), @too_short_title)

      assert json_response(conn, 400)["errors"] == %{
               "title" => ["should be at least 3 character(s)"]
             }
    end
  end

  describe "update" do
    setup [:put_authorization, :insert_list]

    test "renders 404 if list does not exist", %{conn: conn} do
      conn = put(conn, Routes.api_list_path(conn, :update, 12_324), @valid_title)
      assert response(conn, 404)
    end

    test "renders 400 if change is invalid", %{conn: conn, list: list} do
      conn = put(conn, Routes.api_list_path(conn, :update, list.id), title: "")

      assert json_response(conn, 400)["errors"] == %{
               "title" => ["can't be blank"]
             }
    end

    test "renders 200 if list exists and change is valid", %{conn: conn, list: list} do
      conn = put(conn, Routes.api_list_path(conn, :update, list.id), title: "New Title")
      assert json_response(conn, 200)["data"]["title"] == "New Title"
    end
  end

  describe "delete" do
    setup [:put_authorization, :insert_list]

    test "responds with 204 after successful deletion", %{conn: conn, list: list} do
      conn = delete(conn, Routes.api_list_path(conn, :delete, list))
      assert response(conn, 204)
    end

    test "responds with 404 if no list is found", %{conn: conn} do
      conn = delete(conn, Routes.api_list_path(conn, :delete, 4))
      assert json_response(conn, 404)
    end
  end
end
