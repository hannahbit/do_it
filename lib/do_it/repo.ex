defmodule DoIt.Repo do
  use Ecto.Repo,
    otp_app: :do_it,
    adapter: Ecto.Adapters.Postgres

  alias DoIt.{List, Todo}

  @list_does_not_exist [
    list: {"does not exist", [constraint: :assoc, constraint_name: "todos_list_id_fkey"]}
  ]

  def get_record(module, id) do
    case get(module, id) do
      nil -> {:error, :not_found}
      record -> {:ok, record}
    end
  end

  def get_list(id) do
    get_record(List, id)
  end

  def create_list(params) do
    List.changeset(%List{}, params) |> insert()
  end

  def update_list(list, title) do
    List.changeset(list, %{title: title})
    |> update()
  end

  def get_todo(id) do
    get_record(Todo, id)
  end

  def check_done(todo) do
    todo
    |> Ecto.Changeset.change(%{done: true})
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
