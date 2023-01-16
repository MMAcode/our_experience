defmodule OurExperience.Repo.Migrations.AddStatusColumnTo_UStrategy do
  use Ecto.Migration

  def change do
    alter table (:u_strategies) do
      add :status, :string
    end
  end
end
