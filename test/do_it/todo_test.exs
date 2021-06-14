defmodule DoIt.TodoTest do
  use DoIt.DataCase, async: true
  alias DoIt.Todo
  alias DoIt.Repo

  @long_description String.duplicate("a", 101)

  describe "create_changeset/1" do
    test "description must be at least three characters long" do
      changeset = Todo.create_changeset(%{description: "In", list_id: 1})
      assert errors_on(changeset) == %{description: ["should be at least 3 character(s)"]}
    end

    test "description must be at most 100 characters long" do
      changeset = Todo.create_changeset(%{description: @long_description, list_id: 1})
      assert errors_on(changeset) == %{description: ["should be at most 100 character(s)"]}
    end

    test "todo must have a description" do
      changeset = Todo.create_changeset(%{list_id: 1})
      assert errors_on(changeset) == %{description: ["can't be blank"]}
    end

    test "todo with description between 3 and 100 chars has valid changeset" do
      changeset = Todo.create_changeset(%{description: "Nice description", list_id: 1})
      assert changeset.changes.description == "Nice description"
    end

    test "todo must have a list_id" do
      changeset = Todo.create_changeset(%{description: "Water plants"})
      assert errors_on(changeset) == %{list_id: ["can't be blank"]}
    end

    test "todos list_id must belong to an existing list" do
      todo_changeset = Todo.create_changeset(%{description: "Water plants", list_id: 1})
      {:error, changeset} = Repo.insert(todo_changeset)
      assert errors_on(changeset) == %{list: ["does not exist"]}
    end
  end
end
