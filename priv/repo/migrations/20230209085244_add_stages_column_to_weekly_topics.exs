defmodule OurExperience.Repo.Migrations.AddStagesColumnToWeeklyTopics do
  use Ecto.Migration

  def change do
        alter table(:weekly_topics) do
      add :stage, :string
    end
  end
end
