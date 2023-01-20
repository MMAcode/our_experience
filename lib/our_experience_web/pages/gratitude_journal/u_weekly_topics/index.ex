defmodule OurExperienceWeb.Pages.GratitudeJournal.UWeeklyTopics.Index do
  use OurExperienceWeb, :live_view
  # on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h3>Your "weekly topics" for 'Themed Gratitude Journal'</h3>
    """
  end
end
