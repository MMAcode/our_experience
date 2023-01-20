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
      <.b_link to={~p"/my_experience/u_weekly_topics/"}>My weekly_topics</.b_link>
      <br />
    </div>
    """
  end
end
