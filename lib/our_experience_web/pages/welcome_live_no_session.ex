defmodule OurExperienceWeb.Pages.WelcomeLiveNoSession do
  use OurExperienceWeb, :live_view

  # on_mount {OurExperienceWeb.Auth.AuthForLive, :matchThisInner}

  def mount(_params, session, socket) do
    {:ok, assign(socket, :current_user,  Map.get(session, "current_user"))}
  end

  def render(assigns) do
    ~H"""
    <div class="container text-center">
      <h2 class="">Welcome to <strong>Our Experience</strong> project</h2>
      <p class="">(Created by Miroslav Makarov)</p>
      <br/>
      <p>...work in progress...</p>



      <p> This is public live page without live session wrapper</p>

    </div>
    """
  end
end
