defmodule OurExperienceWeb.U_WeeklyTopicLive.Show do
  use OurExperienceWeb, :live_view
  alias OurExperience.CONSTANTS
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopics
#   on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :base_path, CONSTANTS.url_paths().base_for.u_weekly_topics)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:u__weekly_topic, U_WeeklyTopics.get_u__weekly_topic!(id))}
  end

  defp page_title(:show), do: "Show U  weekly topic"
  defp page_title(:edit), do: "Edit U  weekly topic"
end
