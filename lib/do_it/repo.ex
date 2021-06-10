defmodule DoIt.Repo do
  use Ecto.Repo,
    otp_app: :do_it,
    adapter: Ecto.Adapters.Postgres
    alias DoIt.List

  def get_list(id) do
    case get(List, id) do
      nil -> {:error, :not_found}
      %List{} = list -> {:ok, list}
    end
  end

  def create_list(params) do
    List.create_changeset(params) |> insert()
  end
end
