defmodule OurExperience.Users.User do
  alias OurExperience.U_Strategies.U_Strategy
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :admin_level, :integer
    has_many :u_strategies, U_Strategy

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
