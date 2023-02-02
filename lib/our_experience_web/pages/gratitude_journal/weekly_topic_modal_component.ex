defmodule OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent do
  import OurExperienceWeb.CoreComponents

  use Phoenix.Component

  attr :id, :string, doc: "Id of the html element of this specific modal"
  attr :weekly_topic, :map, doc: "Weekly topic to display in the modal"
  def weekly_topic_modal_component(assigns) do
    ~H"""
    <.modal id={@id}>
      <h4>Title</h4>
      <p><%= @weekly_topic.title %></p>
      <h4>Summary</h4>
      <p><%= @weekly_topic.summary %></p>
      <h4>Content</h4>
      <p><%= @weekly_topic.content %></p>
      <h4>Day by day instructions</h4>
      <p><%= @weekly_topic.day_by_day_instructions %></p>
    </.modal>
    """
  end
end
