defmodule OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate do
  alias OurExperience.Users
  use OurExperienceWeb, :live_view
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  # def mount(_params, _session, %{current_user: user} = socket) do
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do


    # user = Users.get_user_by_email(user.email)
    user = Users.get_user_for_TGJ(user.id)
    dbg ["aaa", user]

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h3>Themed Gratitude Journal 1.0 - private</h3>

    <.button phx-click="do">test_me</.button>
    """
  end

  def handle_event("do", _attrs, %{assigns: %{current_user: user}} = socket) do
    # U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
    # U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
    # U_Strategies.create_u__strategy(%{user_id: user.id})

    {:noreply, socket}
  end

  def handle_event("start-gratitude-journal", _attrs, %{assigns: %{current_user: user}} = socket) do
    # create u_strategy
    gj_strategy_id = OurExperience.Strategies.get_strategy_themed_gratitude_journal().id

    """
         1) check if user already has that strategy active
         1.1) if no, create u_strategy and

    """

    {:noreply, socket}
  end
end
