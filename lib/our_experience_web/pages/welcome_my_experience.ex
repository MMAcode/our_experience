defmodule OurExperienceWeb.Pages.WelcomeMyExperience do
  use OurExperienceWeb, :live_view
  alias OurExperienceWeb.Pages.GratitudeJournal.GJ_texts

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
    <.link patch={~p"/my_experience/u_weekly_topics/"}>
      <.button>My weekly_topics</.button>
     </.link>

      <%!-- <h3> current user: --%>
      <%!-- <%= if (@current_user != nil), do: @current_user.email, else: "no user" %> --%>
      <%!-- </h3> --%>
<br/>



    </div>
    """
  end
end
