defmodule OurExperience.U_StrategiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OurExperience.U_Strategies` context.
  """

  @doc """
  Generate a u__strategy.
  """
  def u__strategy_fixture(attrs \\ %{}) do
    {:ok, u__strategy} =
      attrs
      |> Enum.into(%{})
      |> OurExperience.U_Strategies.create_u__strategy()

    u__strategy
  end
end
