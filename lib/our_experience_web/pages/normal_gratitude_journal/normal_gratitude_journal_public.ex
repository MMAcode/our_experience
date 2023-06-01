defmodule OurExperienceWeb.Pages.NormalGratitudeJournal.NormalGratitudeJournalPublic do
  use OurExperienceWeb, :live_view
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h3>Gratitude Journal 1.0 - public</h3>
    <.b_link to={~p"/my_experience/strategies/gratitude_journal"}>
      Start using <strong>Gratitude Journal</strong>
    </.b_link>
    """
  end
end
