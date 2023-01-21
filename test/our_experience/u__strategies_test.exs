defmodule OurExperience.U_Strategies.U_StrategiesTest do
  use OurExperience.DataCase

  alias OurExperience.U_Strategies.U_Strategies

  describe "u_strategies" do
    alias OurExperience.U_Strategies.U_Strategy

    import OurExperience.U_StrategiesFixtures

    @invalid_attrs %{}

    test "list_u_strategies/0 returns all u_strategies" do
      u__strategy = u__strategy_fixture()
      assert U_Strategies.list_u_strategies() == [u__strategy]
    end

    test "get_u__strategy!/1 returns the u__strategy with given id" do
      u__strategy = u__strategy_fixture()
      assert U_Strategies.get_u__strategy!(u__strategy.id) == u__strategy
    end

    test "create_u__strategy/1 with valid data creates a u__strategy" do
      valid_attrs = %{}

      assert {:ok, %U_Strategy{} = u__strategy} = U_Strategies.create_u__strategy(valid_attrs)
    end

    test "create_u__strategy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = U_Strategies.create_u__strategy(@invalid_attrs)
    end

    test "update_u__strategy/2 with valid data updates the u__strategy" do
      u__strategy = u__strategy_fixture()
      update_attrs = %{}

      assert {:ok, %U_Strategy{} = u__strategy} =
               U_Strategies.update_u__strategy(u__strategy, update_attrs)
    end

    test "update_u__strategy/2 with invalid data returns error changeset" do
      u__strategy = u__strategy_fixture()

      assert {:error, %Ecto.Changeset{}} =
               U_Strategies.update_u__strategy(u__strategy, @invalid_attrs)

      assert u__strategy == U_Strategies.get_u__strategy!(u__strategy.id)
    end

    test "delete_u__strategy/1 deletes the u__strategy" do
      u__strategy = u__strategy_fixture()
      assert {:ok, %U_Strategy{}} = U_Strategies.delete_u__strategy(u__strategy)
      assert_raise Ecto.NoResultsError, fn -> U_Strategies.get_u__strategy!(u__strategy.id) end
    end

    test "change_u__strategy/1 returns a u__strategy changeset" do
      u__strategy = u__strategy_fixture()
      assert %Ecto.Changeset{} = U_Strategies.change_u__strategy(u__strategy)
    end
  end
end
