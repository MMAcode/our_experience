defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "u_weekly_topics" do
    field :active, :boolean, default: false
    field :position, :integer
    field :u_strategy_id, :id
    field :weekly_topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(u__weekly_topic, attrs) do
    u__weekly_topic
    |> cast(attrs, [:position, :active])
    |> validate_required([:position, :active])
  end
end
