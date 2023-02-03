defmodule OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPublic do
  use OurExperienceWeb, :live_view
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h3>Themed Gratitude Journal 1.0 - public</h3>
    <.b_link to={~p"/my_experience/strategies/themed_gratitude_journal"}>
      Start using <strong> Themed Gratitude Journal</strong>
    </.b_link>
              <div id="editorWrapper" phx-update="ignore">
        <div id="editor" phx-hook="TextEditor" />
      </div>
    """
  end

  def handle_event("start-gratitude-journal", _attrs, %{assigns: %{current_user: user}} = socket) do
    # create u_strategy
    gj_strategy_id =
      OurExperience.Strategies.Strategies.get_strategy_themed_gratitude_journal().id

    """
         1) check if user already has that strategy active
         1.1) if no, create u_strategy and

    """

    {:noreply, socket}
  end
end
