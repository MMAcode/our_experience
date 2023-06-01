defmodule OurExperience.Seeds.StrategiesSeeds do
  alias OurExperience.Strategies.Strategy
  alias OurExperience.Repo

  # mix run priv/repo/seeds.exs -> will run also this one

  def seeds_execution_trigger() do
    createAllStrategies()
  end

  defp createAllStrategies() do
    createStrategy_ThemedGratitudeJournal()
    createStrategy_GratitudeJournal()
  end

  defp createStrategy_ThemedGratitudeJournal() do
    Repo.insert!(
      %Strategy{name: "Themed Gratitude Journal"},
      on_conflict: :nothing
    )
  end

  defp createStrategy_GratitudeJournal() do
    Repo.insert!(
      %Strategy{name: "Gratitude Journal"},
      on_conflict: :nothing
    )
  end
end
