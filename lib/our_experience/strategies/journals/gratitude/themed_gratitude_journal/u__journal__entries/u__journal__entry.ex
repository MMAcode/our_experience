defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entry do
  use Ecto.Schema
  use StructAccess
  import Ecto.Changeset
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Users.User

  schema "u_journal_entries" do
    field :content, :map

    belongs_to :user, User
    belongs_to :u_strategy, U_Strategy

    timestamps()
  end

  @doc false
  # def changeset(%U_Journal_Entry{} = u__journal__entry, attrs) do
  def changeset(entry, attrs) do
    attrs = decode_content_if_needed(attrs)

    entry
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end

  defp decode_content_if_needed(attrs) do
    data = Map.get(attrs, "content")
    cond do
      !is_binary(data) -> attrs
      {:ok, dataJ} = Jason.decode(data) -> Map.replace!(attrs, "content", dataJ)
      true -> attrs
    end
  end
end
