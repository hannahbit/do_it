defmodule DoIt.Todo do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    belongs_to :list, DoIt.List
    field :done, :boolean, default: false
    field :description, :string

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:description, :done, :list_id])
    |> validate_required([:list_id])
    |> validate_description()
    |> assoc_constraint(:list)
  end

  def update_changeset(todo, attrs) do
    todo
    |> cast(attrs, [:description, :done])
    |> validate_description()
  end

  defp validate_description(todo) do
    todo
    |> validate_required([:description])
    |> validate_length(:description, min: 3, max: 100)
  end
end
