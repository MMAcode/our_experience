defmodule OurExperienceWeb.Pages.WelcomeLive do
  use OurExperienceWeb, :live_view
  alias OurExperienceWeb.Pages.Public.Intro.InformationTexts
  alias OurExperienceWeb.Pages.GratitudeJournal.GJ_texts
# alias OurExperienceWeb.MiroComponents
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
      <.admin_level current_user={@current_user}>
        <.b_link to={~p"/strategies/themed_gratitude_journal/"}>Learn more about Themed Gratitude Journal</.b_link>
        <.b_link to={~p"/admin/weekly_topics/"}>weekly_topics</.b_link>
        <.b_link to={~p"/my_experience/u_weekly_topics/"}>My weekly_topics</.b_link>
      </.admin_level>
    <InformationTexts.introduction />
    <GJ_texts.public_introduction />
÷ƒ        <.b_link to={~p"/strategies/themed_gratitude_journal/"}>Start or learn more about Themed Gratitude Journal</.b_link>
    """
  end
end
