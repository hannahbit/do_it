defmodule DoIt.TodoTest do
  use DoIt.DataCase, async: true
  alias DoIt.Todo
  alias DoIt.Repo

  @long_description "This is a very long description. It is longer than onehundred characters. This is really very long. Who would give their todo list such a long description?"

  test "description must be at least three characters long" do
    changeset = Todo.create_changeset(%Todo{list_id: 1}, %{description: "In"})
    assert errors_on(changeset) == %{description: ["should be at least 3 character(s)"]}
  end

  test "description must be at most 100 characters long" do
    changeset = Todo.create_changeset(%Todo{list_id: 1}, %{description: @long_description})
    assert errors_on(changeset) == %{description: ["should be at most 100 character(s)"]}
  end

  test "todo must have a description" do
    changeset = Todo.create_changeset(%Todo{list_id: 1}, %{})
    assert errors_on(changeset) == %{description: ["can't be blank"]}
  end

  test "todo with description between 3 and 100 chars has valid changeset" do
    changeset = Todo.create_changeset(%Todo{list_id: 1}, %{description: "Nice description"})
    assert changeset.changes.description == "Nice description"
  end

  test "todo must have a list_id" do
    changeset = Todo.create_changeset(%Todo{}, %{description: "Water plants"})
    assert errors_on(changeset) == %{list_id: ["can't be blank"]}
  end

  test "todos list_id must belong to an existing list" do
    todo = Ecto.build_assoc(%DoIt.List{id: 4}, :todos)
    todo_changeset = Todo.create_changeset(todo, %{description: "Water plants"})
    {:error, changeset} = Repo.insert(todo_changeset)
    assert errors_on(changeset) == %{list: ["does not exist"]}
  end

  test "todo associated with existing list and description
        with 3-100 chars is saved to the database" do
    {:ok, list} = Repo.create_list(%{title: "New List"})
    todo = Ecto.build_assoc(list, :todos)
    todo_changeset = Todo.create_changeset(todo, %{description: "Water plants"})
    assert {:ok, todo} = Repo.insert(todo_changeset)
    assert todo.list_id == list.id
  end
end
