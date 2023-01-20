defmodule OurExperienceWeb.Pages.WelcomeMyExperience do
  use OurExperienceWeb, :live_view
  alias OurExperience.Strategies
  alias OurExperience.CONSTANTS
  alias OurExperience.Repo
  alias OurExperience.U_Strategies
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Users


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


      <%!-- </.link> --%>
    </div>
    """
  end


end
