defmodule OurExperience.Strategies.Strategies do
  @moduledoc """
  The Strategies context.
  """

  import Ecto.Query, warn: false
  alias OurExperience.Repo

  alias OurExperience.Strategies.Strategy

  @doc """
  Returns the list of strategies.

  ## Examples

      iex> list_strategies()
      [%Strategy{}, ...]

  """
  def list_strategies do
    Repo.all(Strategy)
  end

  @doc """
  Gets a single strategy.

  Raises `Ecto.NoResultsError` if the Strategy does not exist.

  ## Examples

      iex> get_strategy!(123)
      %Strategy{}

      iex> get_strategy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_strategy!(id), do: Repo.get!(Strategy, id)
  def get_strategy_by_name(name), do: Repo.get_by(Strategy, name: name)

  def get_strategy_normal_gratitude_journal,
    do:
      Repo.get_by(Strategy,
        name: OurExperience.CONSTANTS.strategies().name.normal_gratitude_journal
      )

  def get_strategy_themed_gratitude_journal,
    do:
      Repo.get_by(Strategy,
        name: OurExperience.CONSTANTS.strategies().name.themed_gratitude_journal
      )

  @doc """
  Creates a strategy.

  ## Examples

      iex> create_strategy(%{field: value})
      {:ok, %Strategy{}}

      iex> create_strategy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_strategy(attrs \\ %{}) do
    %Strategy{}
    |> Strategy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a strategy.

  ## Examples

      iex> update_strategy(strategy, %{field: new_value})
      {:ok, %Strategy{}}

      iex> update_strategy(strategy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_strategy(%Strategy{} = strategy, attrs) do
    strategy
    |> Strategy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a strategy.

  ## Examples

      iex> delete_strategy(strategy)
      {:ok, %Strategy{}}

      iex> delete_strategy(strategy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_strategy(%Strategy{} = strategy) do
    Repo.delete(strategy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking strategy changes.

  ## Examples

      iex> change_strategy(strategy)
      %Ecto.Changeset{data: %Strategy{}}

  """
  def change_strategy(%Strategy{} = strategy, attrs \\ %{}) do
    Strategy.changeset(strategy, attrs)
  end
end
