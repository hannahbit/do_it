defmodule DoIt.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    belongs_to :list, DoIt.List
    field :checked, :boolean, default: false
    field :description, :string

    timestamps()
  end

  @doc false
  def create_changeset(todo, attrs) do
    todo
    |> cast(attrs, [:description, :checked])
    |> validate_required([:description, :list_id])
    |> validate_length(:description, min: 3, max: 100)
    |> assoc_constraint(:list)
  end
end