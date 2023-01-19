defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic do
  alias OurExperience.Users.User
  alias OurExperience.U_Strategies.U_Strategy

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic

  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset

  schema "u_weekly_topics" do
    field :active, :boolean, default: false
    field :position, :integer

    belongs_to :user, User
    belongs_to :u_strategy, U_Strategy
    belongs_to :weekly_topic, WeeklyTopic

    timestamps()
  end

  @doc false
  def changeset(u__weekly_topic, attrs) do
    u__weekly_topic
    |> cast(attrs, [:position, :active])
    |> validate_required([:position, :active])
    |> unique_constraint([:position])
  end
end
