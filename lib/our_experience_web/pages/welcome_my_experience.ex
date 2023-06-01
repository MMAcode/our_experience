defmodule OurExperienceWeb.Pages.WelcomeMyExperience do
  use OurExperienceWeb, :live_view
  alias OurExperience.Strategies.Strategies
  alias OurExperience.CONSTANTS
  alias OurExperience.Repo
  alias OurExperience.U_Strategies.U_Strategies
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Users.Users

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
      <.b_link to={~p"/my_experience/strategies/gratitude_journal"}>
        <strong> Gratitude Journal</strong>
      </.b_link>
      <.b_link to={~p"/my_experience/strategies/themed_gratitude_journal"}>
        <strong> Themed Gratitude Journal</strong>
      </.b_link>
      <br />
    </div>
    """
  end
end
