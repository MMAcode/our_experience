defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings` context.
  """

  @doc """
  Generate a u__weekly_topic_rating.
  """
  def u__weekly_topic_rating_fixture(attrs \\ %{}) do
    {:ok, u__weekly_topic_rating} =
      attrs
      |> Enum.into(%{
        after_first_view: %{},
        after_first_week: %{},
        manual_activations: %{}
      })
      |> OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings.create_u__weekly_topic_rating()

    u__weekly_topic_rating
  end
end
