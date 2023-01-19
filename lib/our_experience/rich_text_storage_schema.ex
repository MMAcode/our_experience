defmodule OurExperience.RichTextStorageSchema do
  use Ecto.Schema
  use StructAccess

  import Ecto.Changeset

  schema "rich_text_storage_test" do
    field :data, :map

    timestamps()
  end

  @doc false
  def changeset(rich_text_storage_test, attrs) do
    # MAIN section - convert text to map to save to db
    data = Map.get(attrs, "data")

    attrs =
      if is_binary(data) do
        {status, dataJ} = Jason.decode(data)

        if status == :ok do
          Map.replace!(attrs, "data", dataJ)
        else
          attrs
        end
      else
        attrs
      end

    rich_text_storage_test
    |> cast(attrs, [:data])

    # |> validate_required([:data])
  end
end
