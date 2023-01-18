defmodule OurExperience.Repo.Migrations.CreateUWeeklyTopicRatings do
  use Ecto.Migration

  def change do
    create table(:u_weekly_topic_ratings) do
      add :after_first_view, :map
      add :after_first_week, :map
      add :manual_activations, :map
      add :u_strategy_id, references(:u_strategies, on_delete: :nothing)
      add :u_weekly_topic_id, references(:u_weekly_topics, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :weekly_topic_id, references(:weekly_topics, on_delete: :nothing)

      timestamps()
    end

    create index(:u_weekly_topic_ratings, [:u_strategy_id])
    create index(:u_weekly_topic_ratings, [:u_weekly_topic_id])
    create index(:u_weekly_topic_ratings, [:user_id])
    create index(:u_weekly_topic_ratings, [:weekly_topic_id])
  end
end
