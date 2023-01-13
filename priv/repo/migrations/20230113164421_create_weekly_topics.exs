defmodule OurExperience.Repo.Migrations.CreateWeeklyTopics do
  use Ecto.Migration

  def change do
    create table(:weekly_topics) do
      add :title, :string
      add :content, :text
      add :default_position, :integer
      add :default_active_status, :boolean, default: false, null: false

      timestamps()
    end
  end
end
