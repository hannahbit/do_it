defmodule DoItWeb.FallbackController do
  use DoItWeb, :controller

  @list_does_not_exist [
    list: {"does not exist", [constraint: :assoc, constraint_name: "todos_list_id_fkey"]}
  ]

  def call(conn, {:error, %Ecto.Changeset{} = changeset})
      when changeset.errors == @list_does_not_exist do
    call(conn, {:error, :not_found})
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(400)
    |> put_view(DoItWeb.ErrorView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DoItWeb.ErrorView)
    |> render(:"404")
  end
end
