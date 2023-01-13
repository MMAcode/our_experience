defmodule OurExperience.StrategiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OurExperience.Strategies` context.
  """

  @doc """
  Generate a strategy.
  """
  def strategy_fixture(attrs \\ %{}) do
    {:ok, strategy} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> OurExperience.Strategies.create_strategy()

    strategy
  end
end
