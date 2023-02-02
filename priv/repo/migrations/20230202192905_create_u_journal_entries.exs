defmodule OurExperience.Repo.Migrations.CreateUJournalEntries do
  use Ecto.Migration

  def change do
    create table(:u_journal_entries) do
      add :content, :map
      add :user_id, references(:users, on_delete: :nothing)
      add :u_strategy_id, references(:u_strategies, on_delete: :nothing)

      timestamps()
    end

    create index(:u_journal_entries, [:user_id])
    create index(:u_journal_entries, [:u_strategy_id])
  end
end
