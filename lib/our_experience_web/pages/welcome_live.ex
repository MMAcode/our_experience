defmodule OurExperienceWeb.Pages.WelcomeLive do
  use OurExperienceWeb, :live_view
  alias OurExperienceWeb.Pages.Public.Intro.DocsAsFuncs

  on_mount {OurExperienceWeb.Auth.AuthForLive, :matchThisInner}

  def mount(_params, session, socket) do
    {:ok, assign(socket, :current_user, Map.get(session, "current_user"))}
  end

  def render(assigns) do
    ~H"""
    <div class="container text-center">
      <h2 class="">Welcome to <strong>Our Experience</strong> project</h2>
      <p class="">(Created by Miroslav Makarov)</p>
      <p>...work in progress...</p>
    </div>
      <DocsAsFuncs.introduction/>
    """
  end
end
