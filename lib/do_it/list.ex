defmodule DoIt.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :title, :string

    timestamps()
  end

  @doc false
  def create_changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 3, max: 100)
  end
end
