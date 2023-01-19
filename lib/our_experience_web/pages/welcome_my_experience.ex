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
    dbg(["user in private live mount: ", user])
    {:ok, assign(socket, :current_user,  Map.get(session, "current_user"))}
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

      <%!-- <h3> current user: --%>
      <%!-- <%= if (@current_user != nil), do: @current_user.email, else: "no user" %> --%>
      <%!-- </h3> --%>
    <br/>
    <%!-- <.link navigate={~p"/my_experience/strategies/themed_gratitude_journal/u_weekly_topics"}> --%>
      <.button phx-click="start-gratitude-journal">Start using <strong> Themed Gratitude Journal </strong> </.button>
     <%!-- </.link> --%>
    </div>
    """
  end

  def handle_event("start-gratitude-journal", _attrs, socket) do
    dbg ["hiio", socket.assigns.current_user]

    {:noreply, socket}
  end
end
