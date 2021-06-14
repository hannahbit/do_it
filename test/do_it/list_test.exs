defmodule DoIt.ListTest do
  use DoIt.DataCase, async: true
  alias DoIt.List

  @long_title "This is a very long title. It is longer than onehundred characters. This is really very long. Who would give their todo list such a long title?"

  test "title must be at least three characters long" do
    changeset = List.changeset(%List{}, %{title: "In"})
    assert %{title: ["should be at least 3 character(s)"]} = errors_on(changeset)
  end

  test "title must be at most 100 characters long" do
    changeset = List.changeset(%List{}, %{title: @long_title})
    assert %{title: ["should be at most 100 character(s)"]} = errors_on(changeset)
  end

  test "title with more than 3 and less than 100 chars has valid changeset" do
    changeset = List.changeset(%List{}, %{title: "Nice Title"})
    assert changeset.changes.title == "Nice Title"
  end

  test "list must have a title" do
    changeset = List.changeset(%List{}, %{})
    assert %{title: ["can't be blank"]} = errors_on(changeset)
  end
end
