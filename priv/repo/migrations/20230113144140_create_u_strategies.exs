defmodule OurExperience.Repo.Migrations.CreateUStrategies do
  use Ecto.Migration

  def change do
    create table(:u_strategies) do
      add :strategy_id, references(:strategies, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:u_strategies, [:strategy_id])
    create index(:u_strategies, [:user_id])
  end
end
