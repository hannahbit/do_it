defmodule DoItWeb.ListControllerTest do
  use DoItWeb.ConnCase
  alias DoIt.List
  alias DoIt.Repo

  describe "show" do
    test "renders list when list with that id exists", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "Hello"})
      conn = get(conn, Routes.list_path(conn, :show, list.id))
      assert json_response(conn, 200)["data"] == %{"title" => "Hello"}
    end

    test "renders 404 error when list with that id does not exists", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :show, 123786876))
      assert json_response(conn, 404) == "Not Found"
    end
  end

  describe "create" do
    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), title: "Good Title")
      assert json_response(conn, 200)["data"] == %{"title" => "Good Title"}
    end

    test "renders error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), title: "Go")

      assert json_response(conn, 400)["errors"] == %{"title" => ["should be at least 3 character(s)"]}

    end
  end

  describe "delete" do
    test "responds with 200 after successful deletion", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "Title"})
      conn = delete(conn, Routes.list_path(conn, :delete, list))
      assert json_response(conn, 200)
    end

    test "responds with 404 if no list is found", %{conn: conn} do
      conn = delete(conn, Routes.list_path(conn, :delete, 4))
      assert json_response(conn, 404)
    end
  end
end
