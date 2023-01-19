defmodule OurExperience.U_Strategies.U_Strategy do
  alias OurExperience.Strategies.Strategy
  alias OurExperience.Users.User
  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset

  schema "u_strategies" do
    field :status, :string     # "on", "off" ("archived")

    belongs_to :user, User
    belongs_to :strategy, Strategy

    timestamps()
  end

  @doc false
  def changeset(u__strategy, attrs) do
    u__strategy
    |> cast(attrs, [])
    |> validate_required([])
  end
end
