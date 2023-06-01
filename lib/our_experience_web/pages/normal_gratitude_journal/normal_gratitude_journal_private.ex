defmodule OurExperienceWeb.Pages.NormalGratitudeJournal.NormalGratitudeJournalPrivate do
  use OurExperienceWeb, :live_view
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns
  alias OurExperience.Users.Users
  alias OurExperience.U_Strategies.U_Strategies

  alias OurExperienceWeb.Pages.NormalGratitudeJournal.Journal.Journal

  def mount(_params, _session, %{assigns: %{current_user: user, live_action: action}} = socket) do
    user_fromDb = Users.get_user_for_NGJ(user.id)
    user_wStrategy = user_with_existing_active_NGJ_strategy(user_fromDb)
    socket = assign(socket, current_user: user_wStrategy)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- <h3>Gratitude Journal 1.0 - private</h3> --%>
    <%= live_render(@socket, Journal, id: "normal_journal") %>
    """
  end

  defp user_with_existing_active_NGJ_strategy(user) do
    case get_active_NGJ_uStrategy_fromLoadedData(user) do
      nil ->
        # dbg "initiating u_str and topics"
        new_u_strategy = U_Strategies.create_u__strategy_NGJ_without_changeset(user.id)
        Users.get_user_for_NGJ(user.id) |> dbg

      _strategy ->
        # dbg "strategy exists"
        user
    end
  end

  def get_active_NGJ_uStrategy_fromLoadedData(user) do
    user.u_strategies
    |> Enum.filter(
      &(&1.strategy.name == OurExperience.CONSTANTS.strategies().name.normal_gratitude_journal &&
          &1.status == OurExperience.CONSTANTS.u_strategies().status.on)
    )
    # newest/biggest date will be first in the list (position 0)
    |> Enum.sort(fn a, b ->
      case Date.compare(a.updated_at, b.updated_at) do
        :lt -> false
        _ -> true
      end
    end)
    |> Enum.at(0)
  end

  @impl true
  def handle_info({:get_assigns_from_parent, journal_pid}, socket) do
    dbg(["joural_liveview_pid --parent - assKeys:", Map.keys(socket.assigns)])
    send(journal_pid, {:assigns_from_parent, socket.assigns})
    {:noreply, socket}
  end
end
