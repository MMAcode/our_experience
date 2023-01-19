defmodule OurExperience.Repo.Migrations.LinkUsersToUserWeeklyTopics do
  use Ecto.Migration

  def change do
    alter table(:u_weekly_topics) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
