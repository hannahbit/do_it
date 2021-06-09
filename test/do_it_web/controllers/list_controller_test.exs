defmodule DoItWeb.ListControllerTest do
  use DoItWeb.ConnCase
  alias DoIt.List
  alias DoIt.Repo

  describe "show" do
    test "renders list when list with that id exists", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "Hello"})
      conn = get(conn, Routes.list_path(conn, :show, list.id))
      assert %{"title" => "Hello"} == json_response(conn, 200)["data"]
    end

    test "renders 404 error when list with that id does not exists", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "Huhu"})
      Repo.delete(list)
      conn = get(conn, Routes.list_path(conn, :show, list.id))
      assert "Not Found" == json_response(conn, 404)
    end
  end

  describe "create" do
    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), title: "Good Title")
      assert %{"title" => "Good Title"} == json_response(conn, 200)["data"]
    end

    test "renders error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), title: "Go")

      assert %{"title" => ["should be at least 3 character(s)"]} ==
               json_response(conn, 400)["errors"]
    end
  end
end
