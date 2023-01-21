defmodule OurExperience.U_Strategies.U_Strategies do
  @moduledoc """
  The U_Strategies context.
  """

  import Ecto.Query, warn: false
  alias OurExperience.CONSTANTS
  alias OurExperience.Repo

  alias OurExperience.U_Strategies.U_Strategy

  @doc """
  Returns the list of u_strategies.

  ## Examples

      iex> list_u_strategies()
      [%U_Strategy{}, ...]

  """
  def list_u_strategies do
    Repo.all(U_Strategy)
  end

  @doc """
  Gets a single u__strategy.

  Raises `Ecto.NoResultsError` if the U  strategy does not exist.

  ## Examples

      iex> get_u__strategy!(123)
      %U_Strategy{}

      iex> get_u__strategy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_u__strategy!(id), do: Repo.get!(U_Strategy, id)
  # def get_active_u_strategy_by_user_and__id(id), do: Repo.get_by(U_Strategy, [status: CONSTANTS.u_strategies.status.on])

  @doc """
  Creates a u__strategy.

  ## Examples

      iex> create_u__strategy(%{field: value})
      {:ok, %U_Strategy{}}

      iex> create_u__strategy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_u__strategy(attrs \\ %{}) do
  #   %U_Strategy{}
  #   |> U_Strategy.changeset(attrs)
  #   |> Repo.insert()
  # end

  # u_strategy could be also create using User struct: preload all u_strategies association and then in changeset use cast_assoc and append new

  def create_u__strategy_TGJ_without_changeset(user_id, status \\CONSTANTS.u_strategies.status.on) do
   u_s = %U_Strategy{
      user_id: user_id,
      strategy_id: OurExperience.Strategies.Strategies.get_strategy_themed_gratitude_journal.id,
      status: status
    }

    Repo.insert!(u_s)
  end

  @doc """
  Updates a u__strategy.

  ## Examples

      iex> update_u__strategy(u__strategy, %{field: new_value})
      {:ok, %U_Strategy{}}

      iex> update_u__strategy(u__strategy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_u__strategy(%U_Strategy{} = u__strategy, attrs) do
    u__strategy
    |> U_Strategy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a u__strategy.

  ## Examples

      iex> delete_u__strategy(u__strategy)
      {:ok, %U_Strategy{}}

      iex> delete_u__strategy(u__strategy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_u__strategy(%U_Strategy{} = u__strategy) do
    Repo.delete(u__strategy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking u__strategy changes.

  ## Examples

      iex> change_u__strategy(u__strategy)
      %Ecto.Changeset{data: %U_Strategy{}}

  """
  def change_u__strategy(%U_Strategy{} = u__strategy, attrs \\ %{}) do
    U_Strategy.changeset(u__strategy, attrs)
  end
end
