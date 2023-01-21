defmodule OurExperienceWeb.WeeklyTopicLive.Show do
  use OurExperienceWeb, :live_view

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopics
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:weekly_topic, WeeklyTopics.get_weekly_topic!(id))}
  end

  defp page_title(:show), do: "Show Weekly topic"
  defp page_title(:edit), do: "Edit Weekly topic"
end
