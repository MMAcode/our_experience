defmodule OurExperienceWeb.Pages.WelcomeLive do
  use OurExperienceWeb, :live_view
  alias OurExperienceWeb.Pages.Public.Intro.InformationTexts
  alias OurExperienceWeb.Pages.GratitudeJournal.GJ_texts
  alias OurExperienceWeb.MiroComponents
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container text-center">
      <h2 class="">Welcome to <strong>Our Experience</strong> project</h2>
      <p class="">(Created by Miroslav Makarov)</p>
      <p>...work in progress...</p>
    </div>
    <MiroComponents.admin_level current_user={@current_user}>
     <.link patch={~p"/admin/weekly_topics/"}>
      <.button>weekly_topics</.button>
     </.link>
    <.link patch={~p"/my_experience/u_weekly_topics/"}>
      <.button>My weekly_topics</.button>
     </.link>
     my_experience/u_weekly_topics


            <%!-- <.back navigate={~p"/admin/weekly_topics"}>Weekly_topics</.back> --%>
    </MiroComponents.admin_level>
    <InformationTexts.introduction/>
    <GJ_texts.public_introduction/>
    """
  end
end
