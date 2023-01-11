defmodule OurExperienceWeb.Pages.WelcomeLive do
  use OurExperienceWeb, :live_view
  alias OurExperienceWeb.Pages.Public.Intro.InformationTexts
  alias OurExperienceWeb.MiroComponents
  # on_mount {OurExperienceWeb.Auth.AuthForLive, :matchThisInner}
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
      <p>inner text</p>
    </MiroComponents.admin_level>
    <InformationTexts.introduction/>
    """
  end
end
