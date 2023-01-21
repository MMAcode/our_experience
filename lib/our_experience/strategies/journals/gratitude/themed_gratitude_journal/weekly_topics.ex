defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics do
  import Ecto.Query, warn: false
  alias OurExperience.Repo

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic

  @doc """
  Returns the list of weekly_topics.

  ## Examples

      iex> list_weekly_topics()
      [%WeeklyTopic{}, ...]

  """
  def list_weekly_topics do
    Repo.all(WeeklyTopic)
  end

  @doc """
  Gets a single weekly_topic.

  Raises `Ecto.NoResultsError` if the Weekly topic does not exist.

  ## Examples

      iex> get_weekly_topic!(123)
      %WeeklyTopic{}

      iex> get_weekly_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_weekly_topic!(id), do: Repo.get!(WeeklyTopic, id)

  @doc """
  Creates a weekly_topic.

  ## Examples

      iex> create_weekly_topic(%{field: value})
      {:ok, %WeeklyTopic{}}

      iex> create_weekly_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_weekly_topic(attrs \\ %{}) do
    %WeeklyTopic{}
    |> WeeklyTopic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a weekly_topic.

  ## Examples

      iex> update_weekly_topic(weekly_topic, %{field: new_value})
      {:ok, %WeeklyTopic{}}

      iex> update_weekly_topic(weekly_topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_weekly_topic(%WeeklyTopic{} = weekly_topic, attrs) do
    weekly_topic
    |> WeeklyTopic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a weekly_topic.

  ## Examples

      iex> delete_weekly_topic(weekly_topic)
      {:ok, %WeeklyTopic{}}

      iex> delete_weekly_topic(weekly_topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_weekly_topic(%WeeklyTopic{} = weekly_topic) do
    Repo.delete(weekly_topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking weekly_topic changes.

  ## Examples

      iex> change_weekly_topic(weekly_topic)
      %Ecto.Changeset{data: %WeeklyTopic{}}

  """
  def change_weekly_topic(%WeeklyTopic{} = weekly_topic, attrs \\ %{}) do
    WeeklyTopic.changeset(weekly_topic, attrs)
  end
end
