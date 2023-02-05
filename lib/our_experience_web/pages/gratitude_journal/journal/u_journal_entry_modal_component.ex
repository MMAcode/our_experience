defmodule OurExperienceWeb.Pages.GratitudeJournal.Journal.UJournalEntryModalComponent do
    import OurExperienceWeb.CoreComponents

  use Phoenix.Component
  slot :inner_block, defauld: nil
  attr :id, :string, doc: "Id of the html element of this specific modal"
  # attr :journal_entry, :map, doc: "Weekly topic to display in the modal"
  def journal_entry_modal_component(assigns) do
    ~H"""
    <.modal id={@id}>
      <h2>Journal entry</h2>
      <%!-- <h4>Title</h4>
      <p><%= @journal_entry.title %></p>
      <h4>Summary</h4>
      <p><%= @journal_entry.summary %></p>
      <h4>Content</h4>
      <p><%= @journal_entry.content %></p>
      <h4>Day by day instructions</h4>
      <p><%= @journal_entry.day_by_day_instructions %></p> --%>
      <%= render_slot(@inner_block) %>
    </.modal>
    """
  end
end
