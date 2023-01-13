defmodule OurExperience.Strategies.Strategy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "strategies" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
