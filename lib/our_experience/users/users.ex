defmodule OurExperience.Users.Users do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query, warn: false

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopics

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entry

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
    # Repo.one(
    #   from u in User,
    #     where: u.email == ^email,
    #     left_join: u_s in assoc(u, :u_strategies),
    #     where: u_s.status == "on",
    #     join: s in assoc(u_s, :strategy),
    #     preload: [u_strategies: {u_s, [strategy: s]}]
    # )

    users =
      Repo.all(
        from u in User,
          where: u.email == ^email
        # left_join: u_s in assoc(u, :u_strategies),
        # where: u_s.status == "on",
        # join: s in assoc(u_s, :strategy)
        # preload: [u_strategies: u_s]
      )

    dbg(["mmxx", users])
    Enum.at(users, 0)

    # simpler, but 3 trips to db instead of 1 (and possibly no filtering?)
    # Repo.get_by(User, email: email)
    # |> Repo.preload(u_strategies: [:strategy])
  end

  def get_user_for_NGJ(id) do
    base_query =
      from u in User,
        where: u.id == ^id,
        left_join: u_s in assoc(u, :u_strategies),
        as: :u_s,
        on: u_s.status == "on",
        left_join: s in assoc(u_s, :strategy)

    q_wJE =
      from [u_s: us] in base_query,
        left_join: je in assoc(us, :u_journal_entries),
        order_by: [desc: je.inserted_at]

    preloaded =
      from [u, u_s, s, je] in q_wJE,
        preload: [
          u_strategies: {
            u_s,
            strategy: s, u_journal_entries: je
          }
        ]

    Repo.one(preloaded)
  end

  def get_user_for_TGJ(id) do
    base_query =
      from u in User,
        where: u.id == ^id,
        left_join: u_s in assoc(u, :u_strategies),
        as: :u_s,
        on: u_s.status == "on",
        left_join: s in assoc(u_s, :strategy),
        left_join: uwt in assoc(u_s, :u_weekly_topics)

    q_wWT =
      from [..., anyNameForUWT] in base_query,
        left_join: wt in assoc(anyNameForUWT, :weekly_topic)

    q_wJE =
      from [u_s: us] in q_wWT,
        left_join: je in assoc(us, :u_journal_entries),
        order_by: [desc: je.inserted_at]

    preloaded =
      from [u, u_s, s, uwt, wt, je] in q_wJE,
        preload: [
          u_strategies: {
            u_s,
            strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}, u_journal_entries: je
          }
        ]

    Repo.one(preloaded)

    # Repo.one(
    #   from u in User,
    #     where: u.id == ^id,
    #     left_join: u_s in assoc(u, :u_strategies),
    #     on: u_s.status == "on", #not 'where' because that would remove the row regardles the left join
    #     left_join: s in assoc(u_s, :strategy),
    #     left_join: uwt in assoc(u_s, :u_weekly_topics), #not inner_joint because if there are no topics, it would not load user either
    #     preload: [u_strategies: {u_s, [strategy: s, u_weekly_topics: uwt]}]
    # )

    # Repo.one(
    #   from u in User,
    #     where: u.id == ^id,
    #     left_join: u_s in assoc(u, :u_strategies),
    #     # not 'where' because that would remove the row regardles the left join
    #     on: u_s.status == "on",
    #     left_join: s in assoc(u_s, :strategy),
    #     # not inner_joint because if there are no topics, it would not load user either
    #     left_join: uwt in assoc(u_s, :u_weekly_topics),
    #     left_join: wt in assoc(uwt, :weekly_topic),
    # original working time tested query with probably extra brackets:
    # preload: [u_strategies: {u_s, [strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}]}]
    # preload: [u_strategies: {u_s, strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}}]
    # )

    # with subsections:

    #   base_query =
    #     from u in User,
    #       where: u.id == ^id,
    #       left_join: u_s in assoc(u, :u_strategies),
    #       # not 'where' because that would remove the row regardles the left join
    #       on: u_s.status == "on",
    #       left_join: s in assoc(u_s, :strategy),
    #       # not inner_joint because if there are no topics, it would not load user either
    #       left_join: uwt in assoc(u_s, :u_weekly_topics)
    #       # left_join: wt in assoc(uwt, :weekly_topic),
    #       # preload: [u_strategies: {u_s, strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}}]
    #       # preload: [u_strategies: {u_s, strategy: s, u_weekly_topics: uwt}]

    #       # works:
    # #  new_query = base_query
    # #   |> join(:left, [u, u_s, s, uwt], wt in assoc(uwt, :weekly_topic))
    # #   |> preload([u, u_s, s, uwt, wt], u_strategies: {u_s, strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}})

    # # also works:
    #     new_query = from [u, u_s, s, uwt] in base_query,
    #       left_join: wt in assoc(uwt, :weekly_topic),
    #       preload: [u_strategies: {u_s, strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}}]

    #    Repo.one(new_query)

    # also works:
    # !!! order of arguments matters, name of the argument does not (in 'from' statement)
    # q_wWT = from [..., anyNameForUWT] in base_query,
    #         left_join: wt in assoc(anyNameForUWT, :weekly_topic)
    # new_query = from [u, u_s, s, uwt, wt] in q_wWT,
    #                 preload: [u_strategies: {u_s, strategy: s, u_weekly_topics: {uwt, weekly_topic: wt}}]
    # Repo.one(new_query)

    # with journals, 2 trips to db due to 'function' call in preload:
    # base_query =
    #   from u in User,
    #     where: u.id == ^id,
    #     left_join: u_s in assoc(u, :u_strategies), as: :u_s,
    #     on: u_s.status == "on",
    #     left_join: s in assoc(u_s, :strategy),
    #     left_join: uwt in assoc(u_s, :u_weekly_topics)

    #   q_wWT = from [..., anyNameForUWT] in base_query,
    #           left_join: wt in assoc(anyNameForUWT, :weekly_topic)

    #   # causes second trip to db:
    #   journal_entries_preload = from  U_Journal_Entry

    #   new_query = from [u, u_s, s, uwt, wt] in q_wWT,
    #                     preload: [u_strategies: {
    #                       u_s,
    #                       strategy: s,
    #                       u_weekly_topics: {uwt, weekly_topic: wt},
    #                       u_journal_entries: ^journal_entries_preload  #as 'function' call
    #                     }]
    #  Repo.one(new_query)

    # as multiple queries
    # Repo.one(
    #   from u in User,
    #     where: u.id == ^id,
    #     preload: [u_strategies: [:strategy, u_weekly_topics: :weekly_topic]]
    # )

    # Repo.get_by(User, id: id)
    # |> Repo.preload(u_strategies: [:strategy, :u_weekly_topics])
  end

  def initiate_weekly_topics_for_user(user_id, u_strategy_id) do
    """
    get all topics
    for each map
    save
      through user - u_strategy? probably bad practice as not all strategies have this
      on its own ->
    """

    WeeklyTopics.list_public_weekly_topics()
    |> Enum.map(
      &%U_WeeklyTopic{
        active: false,
        position: &1.default_position,
        user_id: user_id,
        u_strategy_id: u_strategy_id,
        weekly_topic_id: &1.id
      }
    )
    # may be better to use: |> Repo.insert_all()
    |> Enum.each(&Repo.insert!(&1))

    # |> Enum.at(0)

    # dbg weekly_topics

    # Repo.insert_all(%U_WeeklyTopic{}, weekly_topics)
    # Repo.insert_all("u_weekly_topics", weekly_topics)
    # Repo.insert!(weekly_topics)
    #  |> dbg
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
