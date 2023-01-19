defmodule OurExperience.Repo.Migrations.AddAdminLevelColumnToUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin_level, :integer
    end
  end
end
