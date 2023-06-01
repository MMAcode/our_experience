defmodule OurExperience.Repo.Migrations.MakeStrategyNameUnique do
  use Ecto.Migration

  def change do
    create unique_index(:strategies, [:name])
  end
end
