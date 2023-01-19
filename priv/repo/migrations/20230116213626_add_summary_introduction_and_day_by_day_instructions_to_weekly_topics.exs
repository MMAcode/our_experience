defmodule OurExperience.Repo.Migrations.AddSummaryIntroductionAndDayByDayInstructionsToWeeklyTopics do
  use Ecto.Migration

  def change do
    alter table(:weekly_topics) do
      add :summary, :text
      add :introduction, :text
      add :day_by_day_instructions, :text
    end
  end
end
