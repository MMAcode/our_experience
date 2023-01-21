defmodule OurExperienceWeb.WeeklyTopicLive.Index do
  use OurExperienceWeb, :live_view

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopics

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic

  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :weekly_topics, list_weekly_topics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Weekly topic")
    |> assign(:weekly_topic, WeeklyTopics.get_weekly_topic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Weekly topic")
    |> assign(:weekly_topic, %WeeklyTopic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Weekly topics")
    |> assign(:weekly_topic, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    weekly_topic = WeeklyTopics.get_weekly_topic!(id)
    {:ok, _} = WeeklyTopics.delete_weekly_topic(weekly_topic)

    {:noreply, assign(socket, :weekly_topics, list_weekly_topics())}
  end

  defp list_weekly_topics do
    WeeklyTopics.list_weekly_topics()
  end
end
