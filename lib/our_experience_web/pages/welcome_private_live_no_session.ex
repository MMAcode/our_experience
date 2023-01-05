defmodule OurExperienceWeb.Pages.WelcomePrivateLiveNoSession do
  use OurExperienceWeb, :live_view

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
      <br/>
      <p>...work in progress...</p>
      <p> This is private live page without live session wrapper</p>
      <h3> current user:
      <%= if (@current_user != nil), do: @current_user.name, else: "no user" %>
      </h3>

    </div>
    """
  end
end
