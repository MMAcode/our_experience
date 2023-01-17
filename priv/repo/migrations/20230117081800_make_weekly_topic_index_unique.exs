defmodule OurExperience.Repo.Migrations.MakeWeeklyTopicIndexUnique do
  use Ecto.Migration

  def change do
      create unique_index(:weekly_topics, [:default_position])
      create unique_index(:u_weekly_topics, [:position])
  end
end
