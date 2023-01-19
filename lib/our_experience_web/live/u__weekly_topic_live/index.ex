defmodule OurExperienceWeb.U_WeeklyTopicLive.Index do
  use OurExperienceWeb, :live_view
  alias OurExperience.CONSTANTS
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(_params, _session, socket) do
    dbg(CONSTANTS.url_paths().base_for.u_weekly_topics)

    {:ok,
     assign(socket, :u_weekly_topics, list_u_weekly_topics())
     |> assign(:base_path, CONSTANTS.url_paths().base_for.u_weekly_topics)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit U  weekly topic")
    |> assign(:u__weekly_topic, U_WeeklyTopics.get_u__weekly_topic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New U  weekly topic")
    |> assign(:u__weekly_topic, %U_WeeklyTopic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing U weekly topics")
    |> assign(:u__weekly_topic, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    u__weekly_topic = U_WeeklyTopics.get_u__weekly_topic!(id)
    {:ok, _} = U_WeeklyTopics.delete_u__weekly_topic(u__weekly_topic)

    {:noreply, assign(socket, :u_weekly_topics, list_u_weekly_topics())}
  end

  defp list_u_weekly_topics do
    U_WeeklyTopics.list_u_weekly_topics()
  end
end
