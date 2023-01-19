defmodule OurExperienceWeb.Pages.WelcomeMyExperience do
  use OurExperienceWeb, :live_view
  alias OurExperience.Strategies
  alias OurExperience.CONSTANTS
  alias OurExperience.Repo
  alias OurExperience.U_Strategies
  alias OurExperience.U_Strategies.U_Strategy

  # on_mount {OurExperienceWeb.Auth.AuthForLive, :matchThisInner}

  def mount(_params, session, socket) do
    user = Map.get(session, "current_user")
    # dbg(["user in private live mount: ", user])
    {:ok, assign(socket, :current_user, Map.get(session, "current_user"))}
    # {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- <% dbg assigns%> --%>
    <div class="container text-center">
      <h2 class="">Welcome to <strong>Our Experience</strong> project</h2>
      <p class="">(Created by Miroslav Makarov)</p>
      <br />
      <p>...work in progress...</p>
      <.link navigate={~p"/my_experience/u_weekly_topics/"}>
        <.button>My weekly_topics</.button>
      </.link>

      <br />
      <%!-- <.link navigate={~p"/my_experience/strategies/themed_gratitude_journal/u_weekly_topics"}> --%>
      <.button phx-click="start-gratitude-journal">
        Start using <strong> Themed Gratitude Journal </strong>
      </.button>
      <%!-- </.link> --%>
    </div>
    """
  end

  def handle_event("start-gratitude-journal", _attrs, %{assigns: %{current_user: user}} = socket) do
    """
    get weekly topics
    get user
    for this user for each topic create new u-weekly topic
    """


    # create u_strategy
    strategy = Strategies.get_strategy_by_name(CONSTANTS.strategies.name.themed_gratitude_journal) |> dbg



    # Repo.insert!(%U_Strategy{
    #   strategy_id: strategy.id,
    #   user_id: user.id,
    #   status: "on"
    # })

    # U_Strategies.get_u__strategy!(1) |> dbg
    # U_Strategies.list_u_strategies |> dbg



    {:noreply, socket}
  end
end
