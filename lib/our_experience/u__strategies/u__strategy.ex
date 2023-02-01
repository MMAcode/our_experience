defmodule OurExperience.U_Strategies.U_Strategy do
  # alias OurExperience.Users.Users
  alias OurExperience.Strategies.Strategy
  alias OurExperience.Users.User

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset

  schema "u_strategies" do
    # "on", "off" ("archived")
    field :status, :string

    belongs_to :user, User
    belongs_to :strategy, Strategy

    # only for themed_gratitude_journal strategy!
    has_many :u_weekly_topics, U_WeeklyTopic, foreign_key: :u_strategy_id

    timestamps()
  end

  @doc false
  def changeset(u__strategy, attrs \\ %{}) do
    # # NO
    # u__strategy
    # |> cast(attrs, [:status, :user_id, :strategy_id]) #does not allow - foreign key constrains
    # |> validate_required([])

    # # works, but probably do not use because:
    # - put_assoc seems dangerous to me as it is ment to override existing data in db (even though no changes)
    # - it makes 3 queries in total
    u__strategy
    |> cast(attrs, [:status])
    # |> cast(attrs, [:user_id, :strategy_id, :status])
    # |> validate_required([:user_id])
    # |> validate_required([:user_id, :strategy_id])
    # |> unique_constraint(:user_id, name: :user_strategy)
    # |> unique_constraint(:strategy_id, name: :user_strategy)

    |> cast_assoc(:u_weekly_topics, with: &U_WeeklyTopic.changeset/2)
    # |> dbg
  end

  # May the first argument be the owner of the method
  def get_weekly_topic_by_topic_id_from_loaded_data(u__strategy, topic_id) do
    Enum.find(u__strategy.u_weekly_topics,
      fn u_weekly_topic ->
        u_weekly_topic.weekly_topic_id == topic_id
      end)
      |> List.wrap
      |> Enum.map(& &1.weekly_topic)
      |> List.first
  end
end
