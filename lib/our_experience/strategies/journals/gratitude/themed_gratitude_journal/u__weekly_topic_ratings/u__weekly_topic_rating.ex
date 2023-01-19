defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings.U_WeeklyTopicRating do
  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset
  alias OurExperience.Users.User
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic


  schema "u_weekly_topic_ratings" do
    field :after_first_view, :map
    field :after_first_week, :map
    field :manual_activations, :map


    belongs_to :user, User
    belongs_to :u_strategy, U_Strategy
    belongs_to :u_weekly_topic, U_WeeklyTopic
    belongs_to :weekly_topic, WeeklyTopic

    timestamps()
  end

  @doc false
  def changeset(u__weekly_topic_rating, attrs) do
    u__weekly_topic_rating
    |> cast(attrs, [:after_first_view, :after_first_week, :manual_activations])
    # |> validate_required([:after_first_view, :after_first_week, :manual_activations])
  end
end
