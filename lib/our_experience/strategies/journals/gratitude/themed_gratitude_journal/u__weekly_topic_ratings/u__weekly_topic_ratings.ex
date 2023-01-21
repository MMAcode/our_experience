defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings.U_WeeklyTopicRatings do
  @moduledoc """
  The Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings context.
  """

  import Ecto.Query, warn: false
  alias OurExperience.Repo

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings.U_WeeklyTopicRating

  @doc """
  Returns the list of u_weekly_topic_ratings.

  ## Examples

      iex> list_u_weekly_topic_ratings()
      [%U_WeeklyTopicRating{}, ...]

  """
  def list_u_weekly_topic_ratings do
    Repo.all(U_WeeklyTopicRating)
  end

  @doc """
  Gets a single u__weekly_topic_rating.

  Raises `Ecto.NoResultsError` if the U  weekly topic rating does not exist.

  ## Examples

      iex> get_u__weekly_topic_rating!(123)
      %U_WeeklyTopicRating{}

      iex> get_u__weekly_topic_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_u__weekly_topic_rating!(id), do: Repo.get!(U_WeeklyTopicRating, id)

  @doc """
  Creates a u__weekly_topic_rating.

  ## Examples

      iex> create_u__weekly_topic_rating(%{field: value})
      {:ok, %U_WeeklyTopicRating{}}

      iex> create_u__weekly_topic_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_u__weekly_topic_rating(attrs \\ %{}) do
    %U_WeeklyTopicRating{}
    |> U_WeeklyTopicRating.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a u__weekly_topic_rating.

  ## Examples

      iex> update_u__weekly_topic_rating(u__weekly_topic_rating, %{field: new_value})
      {:ok, %U_WeeklyTopicRating{}}

      iex> update_u__weekly_topic_rating(u__weekly_topic_rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_u__weekly_topic_rating(%U_WeeklyTopicRating{} = u__weekly_topic_rating, attrs) do
    u__weekly_topic_rating
    |> U_WeeklyTopicRating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a u__weekly_topic_rating.

  ## Examples

      iex> delete_u__weekly_topic_rating(u__weekly_topic_rating)
      {:ok, %U_WeeklyTopicRating{}}

      iex> delete_u__weekly_topic_rating(u__weekly_topic_rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_u__weekly_topic_rating(%U_WeeklyTopicRating{} = u__weekly_topic_rating) do
    Repo.delete(u__weekly_topic_rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking u__weekly_topic_rating changes.

  ## Examples

      iex> change_u__weekly_topic_rating(u__weekly_topic_rating)
      %Ecto.Changeset{data: %U_WeeklyTopicRating{}}

  """
  def change_u__weekly_topic_rating(%U_WeeklyTopicRating{} = u__weekly_topic_rating, attrs \\ %{}) do
    U_WeeklyTopicRating.changeset(u__weekly_topic_rating, attrs)
  end
end
