defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "u_journal_entries" do
    field :content, :map
    field :user_id, :id
    field :u_strategy_id, :id

    timestamps()
  end

  @doc false
  def changeset(u__journal__entry, attrs) do
    u__journal__entry
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
