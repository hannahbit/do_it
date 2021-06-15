defmodule DoIt.List do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    has_many :todos, DoIt.Todo
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 3, max: 100)
  end
end
