defmodule OurExperience.Users.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias OurExperience.Repo

  alias OurExperience.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  # def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def get_user_by_email(email) do
    Repo.one(
      from u in User,
        where: u.email == ^email,
        left_join: u_s in assoc(u, :u_strategies),
        where: u_s.status == "on",
        join: s in assoc(u_s, :strategy),
        preload: [u_strategies: {u_s, [strategy: s]}]
    )

    # simpler, but 3 trips to db instead of 1 (and possibly no filtering?)
    # Repo.get_by(User, email: email)
    # |> Repo.preload(u_strategies: [:strategy])
  end

  def get_user_for_TGJ(id) do
    Repo.one(
      from u in User,
      where: u.id == ^id,
      left_join: u_s in assoc(u, :u_strategies),
      on: u_s.status == "on", #not 'where' because that would remove the row regardles the left join
      left_join: s in assoc(u_s, :strategy),
      left_join: uwt in assoc(u_s, :u_weekly_topics), #not inner_joint because if there are no topics, it would not load user either
      preload: [u_strategies: {u_s, [strategy: s, u_weekly_topics: uwt]}]
      ) |>dbg

      # Repo.get_by(User, id: id)
      # |> Repo.preload(u_strategies: [:strategy, :u_weekly_topics])
      # |> Repo.preload(u_strategies: [:strategy, :u_topics])
  end

  def initiate_weekly_topics_for_user(id) do
      """
      get all topics
      for each map
      save
        through user - u_strategy? probably bad practice as not all strategies have this
        on its own ->
      """




  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_user(attrs \\ %{}) do
  #   %User{}
  #   |> User.changeset(attrs)
  #   |> Repo.insert()
  # end
  def create_user(email) do
    %User{}
    |> User.changeset(%{email: email})
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
