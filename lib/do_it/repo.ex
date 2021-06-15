defmodule DoIt.Repo do
  use Ecto.Repo,
    otp_app: :do_it,
    adapter: Ecto.Adapters.Postgres

  alias DoIt.List
  alias DoIt.Todo

  def get_list(id) do
    case get(List, id) do
      nil -> {:error, :not_found}
      %List{} = list -> {:ok, list}
    end
  end

  def create_list(params) do
    List.changeset(%List{}, params) |> insert()
  end

  def update_list(list, title) do
    List.changeset(list, %{title: title})
    |> update()
  end

  def get_todo(id) do
    case get(Todo, id) do
      nil -> {:error, :not_found}
      %Todo{} = list -> {:ok, list}
    end
  end
end
