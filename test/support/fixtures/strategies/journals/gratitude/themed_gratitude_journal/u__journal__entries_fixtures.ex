defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_EntriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries` context.
  """

  @doc """
  Generate a u__journal__entry.
  """
  def u__journal__entry_fixture(attrs \\ %{}) do
    {:ok, u__journal__entry} =
      attrs
      |> Enum.into(%{
        content: %{}
      })
      |> OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries.create_u__journal__entry()

    u__journal__entry
  end
end
