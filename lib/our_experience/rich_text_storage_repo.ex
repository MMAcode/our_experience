defmodule OurExperience.RichTextStorageRepo do
  import Ecto.Query, warn: false
  alias OurExperience.Repo
  alias OurExperience.RichTextStorageSchema

    def list_all do
    Repo.all(RichTextStorageSchema)
    # |> fn x -> dbg(["miro25", x]); x end.()
  end

    def create(attrs \\ %{}) do
    %RichTextStorageSchema{}
    |> RichTextStorageSchema.changeset(attrs)
    |> Repo.insert()
  end


end
