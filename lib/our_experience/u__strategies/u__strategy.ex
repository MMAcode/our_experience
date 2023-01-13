defmodule OurExperience.U_Strategies.U_Strategy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "u_strategies" do

    field :strategy_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(u__strategy, attrs) do
    u__strategy
    |> cast(attrs, [])
    |> validate_required([])
  end
end
