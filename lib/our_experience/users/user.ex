defmodule OurExperience.Users.User do
  alias OurExperience.U_Strategies.U_Strategy
  use Ecto.Schema
  import Ecto.Changeset
  use StructAccess

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


  def gj_strategy(user) do
    get_active_TGJ_uStrategy_fromLoadedData(user)
  end
  @spec get_active_TGJ_uStrategy_fromLoadedData(%__MODULE__{}) :: %U_Strategy{} | nil
  def get_active_TGJ_uStrategy_fromLoadedData(user) do
    user.u_strategies
    |> Enum.filter(
      &(&1.strategy.name == OurExperience.CONSTANTS.strategies().name.themed_gratitude_journal &&
          &1.status == OurExperience.CONSTANTS.u_strategies().status.on)
    )
    # newest/biggest date will be first in the list (position 0)
    |> Enum.sort(fn a, b ->
      case Date.compare(a.updated_at, b.updated_at) do
        :lt -> false
        _ -> true
      end
    end)
    |> Enum.at(0)
  end
end
