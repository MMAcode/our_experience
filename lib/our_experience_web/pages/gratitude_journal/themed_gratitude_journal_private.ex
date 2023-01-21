defmodule OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate do
  alias OurExperience.Users.Users
  alias OurExperience.Users.User
  alias OurExperience.U_Strategies.U_Strategies
  alias OurExperience.U_Strategies.U_Strategy

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  use OurExperienceWeb, :live_view
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @doc """
  when new user comes to this url/liveview, new u_strategy (and u_weekly_topics_) will be auto-created for him
  """
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do

    # set new u_strategy and topics, if needed:
    user_fromDb = Users.get_user_for_TGJ(user.id)
    user_wStrategy = if !connected?(socket), do: user_with_existing_active_TGJ_strategy_and_topics(user_fromDb), else: user_fromDb
    socket = assign(socket, current_user: user_wStrategy)
    # dbg user_wStrategy
    # nav to weeklyTopics or Journal:
    socket = case get_active_weekly_topic(user_wStrategy) do
      nil -> assign(socket, render_weekly_topics: true)
      _topic -> assign(socket, render_journal: true)
    end
    dbg socket.assigns


    {:ok, socket}
  end

  @spec get_active_weekly_topic(%User{}) :: %U_WeeklyTopic{} | nil
  defp get_active_weekly_topic(user) do
    u_strategy = get_active_TGJ_uStrategy(user)
# dbg u_strategy
    if !!u_strategy do
      u_strategy.u_weekly_topics
      |> Enum.filter(&(&1.active == true))
      |> Enum.at(0)
    else
      nil
    end
  end

  defp user_with_existing_active_TGJ_strategy_and_topics(user) do
    case get_active_TGJ_uStrategy(user) do
      nil ->
        # dbg "initiating u_str and topics"
        new_u_strategy = U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
        Users.initiate_weekly_topics_for_user(user.id, new_u_strategy.id)
        Users.get_user_for_TGJ(user.id)

      _strategy ->
        # dbg "strategy exists"
        user
    end
  end

  def render(assigns) do
    ~H"""
    <h3>Themed Gratitude Journal 1.0 - private</h3>

    <.button phx-click="do">test_me</.button>
    """
  end

  @spec get_active_TGJ_uStrategy(%User{}) :: %U_Strategy{} | nil
  defp get_active_TGJ_uStrategy(user) do
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
