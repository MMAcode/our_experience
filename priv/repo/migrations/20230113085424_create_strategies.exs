defmodule OurExperience.Repo.Migrations.CreateStrategies do
  use Ecto.Migration

  def change do
    create table(:strategies) do
      add :name, :string

      timestamps()
    end
  end
end
