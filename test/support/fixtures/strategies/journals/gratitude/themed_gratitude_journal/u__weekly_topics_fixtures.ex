defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics` context.
  """

  @doc """
  Generate a u__weekly_topic.
  """
  def u__weekly_topic_fixture(attrs \\ %{}) do
    {:ok, u__weekly_topic} =
      attrs
      |> Enum.into(%{
        active: true,
        position: 42
      })
      |> OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.create_u__weekly_topic()

    u__weekly_topic
  end
end
