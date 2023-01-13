defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics` context.
  """

  @doc """
  Generate a weekly_topic.
  """
  def weekly_topic_fixture(attrs \\ %{}) do
    {:ok, weekly_topic} =
      attrs
      |> Enum.into(%{
        content: "some content",
        default_active_status: true,
        default_position: 42,
        title: "some title"
      })
      |> OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.create_weekly_topic()

    weekly_topic
  end
end
