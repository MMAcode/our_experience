defmodule OurExperience.Strategies.Strategy do
  alias OurExperience.U_Strategies.U_Strategy
  use Ecto.Schema
  use StructAccess

  import Ecto.Changeset

  schema "strategies" do
    field :name, :string
    has_many :u_strategies, U_Strategy

    timestamps()
  end

  @doc false
  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
