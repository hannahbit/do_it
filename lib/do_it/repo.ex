defmodule DoIt.Repo do
  use Ecto.Repo,
    otp_app: :do_it,
    adapter: Ecto.Adapters.Postgres

  alias DoIt.{List, Todo}

  @list_does_not_exist [
    list: {"does not exist", [constraint: :assoc, constraint_name: "todos_list_id_fkey"]}
  ]

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

  def create_todo(params) do
    params
    |> Todo.create_changeset()
    |> insert()
    |> handle_unexisting_list_error()
  end

  defp handle_unexisting_list_error(insert_return) do
    {status, result} = insert_return
    if Map.has_key?(result, :errors) && result.errors == @list_does_not_exist do
      {:error, :not_found}
    else
      {status, result}
    end
  end
end
