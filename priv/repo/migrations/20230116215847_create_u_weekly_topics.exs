defmodule OurExperience.Repo.Migrations.CreateUWeeklyTopics do
  use Ecto.Migration

  def change do
    create table(:u_weekly_topics) do
      add :position, :integer
      add :active, :boolean, default: false, null: false
      add :u_strategy_id, references(:u_strategies, on_delete: :nothing)
      add :weekly_topic_id, references(:weekly_topics, on_delete: :nothing)

      timestamps()
    end

    create index(:u_weekly_topics, [:u_strategy_id])
    create index(:u_weekly_topics, [:weekly_topic_id])
  end
end
