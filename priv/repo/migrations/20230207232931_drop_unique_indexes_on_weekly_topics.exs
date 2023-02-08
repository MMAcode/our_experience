defmodule OurExperience.Repo.Migrations.DropUniqueIndexesOnWeeklyTopics do
  use Ecto.Migration

  def change do
    drop unique_index(:weekly_topics, [:default_position])
    drop unique_index(:u_weekly_topics, [:position])
  end
end
