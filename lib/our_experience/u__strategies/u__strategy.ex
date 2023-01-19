defmodule OurExperience.U_Strategies.U_Strategy do
  alias OurExperience.Strategies.Strategy
  alias OurExperience.Users.User
  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset

  schema "u_strategies" do
    # field :strategy_id, :id
    # field :user_id, :id
    field :status, :string  # "on", "off" ("archived")

    belongs_to :user, User
    belongs_to :strategy, Strategy

    # only u_strategies about gratitude journal:
    # has_many :u_weekly_topics, U_WeeklyTopic

    timestamps()
  end

  @doc false
  def changeset(u__strategy, attrs) do
    u__strategy
    |> cast(attrs, [])
    |> validate_required([])
  end
end
