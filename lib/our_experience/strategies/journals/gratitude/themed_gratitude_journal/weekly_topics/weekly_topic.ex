defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weekly_topics" do
    field :content, :string
    field :default_active_status, :boolean, default: false
    field :default_position, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(weekly_topic, attrs) do
    weekly_topic
    |> cast(attrs, [:title, :content, :default_position, :default_active_status])
    |> validate_required([:title, :content, :default_position, :default_active_status])
  end
end
