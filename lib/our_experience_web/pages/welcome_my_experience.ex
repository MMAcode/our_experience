defmodule OurExperienceWeb.Pages.WelcomeMyExperience do
  use OurExperienceWeb, :live_view
  alias OurExperience.Strategies
  alias OurExperience.CONSTANTS
  alias OurExperience.Repo
  alias OurExperience.U_Strategies
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Users

  # on_mount {OurExperienceWeb.Auth.AuthForLive, :matchThisInner}

  def mount(_params, session, socket) do
    {:ok, assign(socket, :current_user, Map.get(session, "current_user"))}
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
      <.button phx-click="do">do</.button>
      <%!-- </.link> --%>
    </div>
    """
  end

  def handle_event("do", _attrs, %{assigns: %{current_user: user}} = socket) do

  U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
  # U_Strategies.create_u__strategy_TGJ_without_changeset(user.id)
  # U_Strategies.create_u__strategy(%{user_id: user.id})

      {:noreply, socket}
  end


  def handle_event("start-gratitude-journal", _attrs, %{assigns: %{current_user: user}} = socket) do
    """
    get weekly topics
    get user
    for this user for each topic create new u-weekly topic
    """


    # create u_strategy
    gj_strategy_id = Strategies.get_strategy_themed_gratitude_journal.id

"""
     1) check if user already has that strategy active
     1.1) if no, create u_strategy and

"""

    {:noreply, socket}
  end
end
