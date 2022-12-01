defmodule OurExperienceWeb.Pages.WelcomeLive do
  use OurExperienceWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container text-center">
      <h2 class="">Welcome to <strong>Our Experience</strong> project</h2>
      <p class="">(Created by Miroslav Makarov)</p>
      <br/>
      <p>...work in progress...</p>

    </div>
    """
  end
end
