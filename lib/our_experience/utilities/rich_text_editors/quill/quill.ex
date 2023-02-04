defmodule OurExperience.Utilities.RichTextEditors.Quill.Quill do
  def printable_quills(quills) do
    quills
    |> Enum.map(fn row -> Jason.encode!(row.data) end)
  end

  def printable_quill(quill_json_map) do
    Jason.encode!(quill_json_map)
  end
end
