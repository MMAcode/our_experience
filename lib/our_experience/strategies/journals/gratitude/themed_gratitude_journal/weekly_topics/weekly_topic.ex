defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic do
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic
  use Ecto.Schema
  use StructAccess

  import Ecto.Changeset

  schema "weekly_topics" do
    field :default_active_status, :boolean, default: false
    field :stage, :string
    field :default_position, :integer
    field :title, :string
    field :summary, :string
    field :introduction, :string
    field :day_by_day_instructions, :string
    field :content, :string

    has_many :u_weekly_topics, U_WeeklyTopic

    timestamps()
  end

  @doc false
  def changeset(weekly_topic, attrs) do
    weekly_topic
    |> cast(attrs, [
      :title,
      :summary,
      :introduction,
      :day_by_day_instructions,
      :content,
      :default_position,
      :default_active_status,
      :stage
    ])
    |> validate_required([:title, :content, :default_position, :default_active_status])
    # |> unique_constraint([:default_position])
  end
end
