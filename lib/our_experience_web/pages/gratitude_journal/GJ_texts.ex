defmodule OurExperienceWeb.Pages.GratitudeJournal.GJ_texts do
  use Phoenix.Component

  def public_introduction(assigns) do
    ~H"""
    <h2>Gratitude Journal</h2>
    <p>intro to Gratitude journal to be written</p>
    <%!-- <.link navigate={~p"/strategies/themed_gratitude_journal"}>
    <.button>Read more about Themed Gratitude Journal</.button>
    </.link> --%>
    """
  end
end
