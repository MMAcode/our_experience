defmodule OurExperience.Seeds.StrategiesSeeds do
  alias OurExperience.Strategies.Strategy
  alias OurExperience.Repo

  def createStrategy() do
    Repo.insert!(%Strategy{
      name: "Themed Gratitude Journal_" <> (DateTime.utc_now() |> DateTime.to_string())
    })
  end
end
