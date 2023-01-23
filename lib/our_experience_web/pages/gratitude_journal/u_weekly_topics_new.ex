defmodule OurExperienceWeb.Pages.GratitudeJournal.UWeeklyTopicsNew do
  use Phoenix.Component
  import OurExperienceWeb.CoreComponents

  def index(assigns) do
    dbg(["NEW", assigns])

    ~H"""
    <h1>Your Weekly topics (new)</h1>

    <%!-- <div :for={topic <- @topics}>
      <.topic title={topic.weekly_topic.title} summary={topic.weekly_topic.summary} />
    </div> --%>
    <%!-- <.simple_form --%>
    <.table id="weekly_topics_new" rows={@topics}>
      <:col :let={topic} label="Title"><%= topic.weekly_topic.title %></:col>
      <:col :let={topic} label="Summary"><%= topic.weekly_topic.summary %></:col>
      <:col :let={topic} label="Active">
        <%= topic.weekly_topic.summary %>
        <%!-- <.input
        type="checkbox"
        label="active"
        value="true"
        name="checkX"
        id="someid"
        /> --%>
      </:col>
    </.table>
    """
  end

  def topic(assigns) do
    ~H"""
    <tr>
      <td>Title: <%= @title %></td>
      <td>Summary: <%= @summary %></td>
    </tr>
    """
  end
end
