defmodule DoItWeb.ListControllerTest do
  use DoItWeb.ConnCase

  describe "create" do
    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), title: "Good Title")
      assert %{"title" => "Good Title"} == json_response(conn, 200)["data"]
    end

    test "renders error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), title: "Go")
      assert %{"title" => ["should be at least 3 character(s)"]} == json_response(conn, 400)["errors"]
    end
  end
end
