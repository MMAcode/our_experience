defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics do
  @moduledoc """
  The Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics context.
  """

  import Ecto.Query, warn: false
  alias OurExperience.Repo

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  @doc """
  Returns the list of u_weekly_topics.

  ## Examples

      iex> list_u_weekly_topics()
      [%U_WeeklyTopic{}, ...]

  """
  def list_u_weekly_topics do
    Repo.all(U_WeeklyTopic)
  end

  @doc """
  Gets a single u__weekly_topic.

  Raises `Ecto.NoResultsError` if the U  weekly topic does not exist.

  ## Examples

      iex> get_u__weekly_topic!(123)
      %U_WeeklyTopic{}

      iex> get_u__weekly_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_u__weekly_topic!(id), do: Repo.get!(U_WeeklyTopic, id)

  @doc """
  Creates a u__weekly_topic.

  ## Examples

      iex> create_u__weekly_topic(%{field: value})
      {:ok, %U_WeeklyTopic{}}

      iex> create_u__weekly_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_u__weekly_topic(attrs \\ %{}) do
    %U_WeeklyTopic{}
    |> U_WeeklyTopic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a u__weekly_topic.

  ## Examples

      iex> update_u__weekly_topic(u__weekly_topic, %{field: new_value})
      {:ok, %U_WeeklyTopic{}}

      iex> update_u__weekly_topic(u__weekly_topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_u__weekly_topic(%U_WeeklyTopic{} = u__weekly_topic, attrs) do
    u__weekly_topic
    |> U_WeeklyTopic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a u__weekly_topic.

  ## Examples

      iex> delete_u__weekly_topic(u__weekly_topic)
      {:ok, %U_WeeklyTopic{}}

      iex> delete_u__weekly_topic(u__weekly_topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_u__weekly_topic(%U_WeeklyTopic{} = u__weekly_topic) do
    Repo.delete(u__weekly_topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking u__weekly_topic changes.

  ## Examples

      iex> change_u__weekly_topic(u__weekly_topic)
      %Ecto.Changeset{data: %U_WeeklyTopic{}}

  """
  def change_u__weekly_topic(%U_WeeklyTopic{} = u__weekly_topic, attrs \\ %{}) do
    U_WeeklyTopic.changeset(u__weekly_topic, attrs)
  end
end
