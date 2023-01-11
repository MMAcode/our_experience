defmodule OurExperience.Repo.Migrations.CreateRichTextStorageTest do
  use Ecto.Migration

  def change do
    create table(:rich_text_storage_test) do
      add :data, :map

      timestamps()
    end
  end
end
