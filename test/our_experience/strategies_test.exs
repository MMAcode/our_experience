defmodule OurExperience.Strategies.StrategiesTest do
  use OurExperience.DataCase

  alias OurExperience.Strategies.Strategies

  describe "strategies" do
    alias OurExperience.Strategies.Strategy

    import OurExperience.StrategiesFixtures

    @invalid_attrs %{name: nil}

    test "list_strategies/0 returns all strategies" do
      strategy = strategy_fixture()
      assert Strategies.list_strategies() == [strategy]
    end

    test "get_strategy!/1 returns the strategy with given id" do
      strategy = strategy_fixture()
      assert Strategies.get_strategy!(strategy.id) == strategy
    end

    test "create_strategy/1 with valid data creates a strategy" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Strategy{} = strategy} = Strategies.create_strategy(valid_attrs)
      assert strategy.name == "some name"
    end

    test "create_strategy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Strategies.create_strategy(@invalid_attrs)
    end

    test "update_strategy/2 with valid data updates the strategy" do
      strategy = strategy_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Strategy{} = strategy} = Strategies.update_strategy(strategy, update_attrs)
      assert strategy.name == "some updated name"
    end

    test "update_strategy/2 with invalid data returns error changeset" do
      strategy = strategy_fixture()
      assert {:error, %Ecto.Changeset{}} = Strategies.update_strategy(strategy, @invalid_attrs)
      assert strategy == Strategies.get_strategy!(strategy.id)
    end

    test "delete_strategy/1 deletes the strategy" do
      strategy = strategy_fixture()
      assert {:ok, %Strategy{}} = Strategies.delete_strategy(strategy)
      assert_raise Ecto.NoResultsError, fn -> Strategies.get_strategy!(strategy.id) end
    end

    test "change_strategy/1 returns a strategy changeset" do
      strategy = strategy_fixture()
      assert %Ecto.Changeset{} = Strategies.change_strategy(strategy)
    end
  end
end
