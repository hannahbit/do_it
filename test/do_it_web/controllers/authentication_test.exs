defmodule DoItWeb.AuthenticationTest do
  use DoItWeb.ConnCase

  @invalid_authentication "Basic " <> Base.encode64("wrong:wrong")

  test "renders 401 when authentication is wrong", %{conn: conn} do
    conn = conn
    |> put_req_header("authorization", @invalid_authentication)
    |> get(Routes.api_list_path(conn, :show, 1))

    assert response(conn, 401) =~ "Unauthorized"
  end

  test "renders 401 wenn authentication is missing", %{conn: conn} do
    conn = get(conn, Routes.api_list_path(conn, :show, 1))
    assert response(conn, 401) =~ "Unauthorized"
  end
end
