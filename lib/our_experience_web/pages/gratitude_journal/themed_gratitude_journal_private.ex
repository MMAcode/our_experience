defmodule OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate do
  alias OurExperience.Users.Users
  alias OurExperience.Users.User
  alias OurExperience.U_Strategies.U_Strategies
  alias OurExperience.U_Strategies.U_Strategy

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  use OurExperienceWeb, :live_view
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  def mount(_params, _session, %{assigns: %{current_user: user} = assigns} = socket) do

if !connected?(socket), do:    _user = Users.get_user_for_TGJ(user.id) |> dbg
    user = if !connected?(socket), do: user_with_existing_active_TGJ_strategy_and_topics(user), else: user
    socket = assign(socket, current_user: user)

    # socket = case get_active_weekly_topic(user) do
    #   nil -> assign(socket, render_weekly_topics: true)
    #   _topic -> assign(socket, render_journal: true)
    # end
    # dbg socket.assigns

    str = get_active_TGJ_Strategy(user)
    # if connected?(socket), do: Users.initiate_weekly_topics_for_user(user.id, str.id)

    {:ok, socket}
  end

  @spec get_active_weekly_topic(%User{}) :: %U_WeeklyTopic{} | nil
  defp get_active_weekly_topic(user) do
    strategy = get_active_TGJ_Strategy(user)

    if !!strategy do
      strategy.u_weekly_topics
      |> Enum.filter(&(&1.active == true))
      |> Enum.at(0)
    else
      nil
    end
  end

  defp user_with_existing_active_TGJ_strategy_and_topics(user) do
    case get_active_TGJ_Strategy(user) do
      nil ->
        U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)

        # copy topics here!!! all NOT active


        Users.get_user_for_TGJ(user.id)

      _strategy ->
        user
    end
  end

  def render(assigns) do
    ~H"""
    <h3>Themed Gratitude Journal 1.0 - private</h3>

    <.button phx-click="do">test_me</.button>
    """
  end

  @spec get_active_TGJ_Strategy(%User{}) :: %U_Strategy{} | nil
  defp get_active_TGJ_Strategy(user) do
    user.u_strategies
    |> Enum.filter(
      &(&1.strategy.name == OurExperience.CONSTANTS.strategies().name.themed_gratitude_journal &&
          &1.status == OurExperience.CONSTANTS.u_strategies().status.on)
    )
    # newest/biggest date will be first in the list (position 0)
    |> Enum.sort(&(&1.updated_at > &2.updated_at))
    |> Enum.at(0)
  end

  def handle_event("do", _attrs, %{assigns: %{current_user: user}} = socket) do
    # U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
    # U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
    # U_Strategies.create_u__strategy(%{user_id: user.id})

    {:noreply, socket}
  end

  def handle_event("start-gratitude-journal", _attrs, %{assigns: %{current_user: user}} = socket) do
    # create u_strategy
    gj_strategy_id = OurExperience.Strategies.Strategies.get_strategy_themed_gratitude_journal().id

    """
         1) check if user already has that strategy active
         1.1) if no, create u_strategy and

    """

    {:noreply, socket}
  end
end
