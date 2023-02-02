defmodule OurExperienceWeb.Pages.GratitudeJournal.Journal.Journal do
  # use Phoenix.Component
  use Phoenix.LiveComponent
  use OurExperienceWeb, :live_view #to be able to use ~p sigil
  # for text_input
  import Phoenix.HTML.Form
  import OurExperienceWeb.CoreComponents
  import OurExperienceWeb.MiroComponents
  import OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.U_Strategies.U_Strategies
  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{current_user: user} = assigns, socket) do
    u_strategy = TGJ.get_active_TGJ_uStrategy(user)

    socket =
      socket
      |> assign(assigns)
      |> assign(:u_str_changeset, U_Strategy.changeset(u_strategy))
      |> assign(:current_weekly_topic, U_Strategy.get_current_weekly_topic_from_loaded_data(u_strategy))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%!-- <% dbg(@u_str_changeset.data) %> --%>
      <h1>Journal</h1>
      <%!-- button to view modal of current active weekly topic --%>
      <.weekly_topic_modal_component id="current_weekly_topic" weekly_topic={@current_weekly_topic} />
      <.button
        phx-click={show_modal("current_weekly_topic")}
        type="button"
        phx-target={@myself}
      >
        View current weekly topic
      </.button>
      <.b_link to={~p"/my_experience/strategies/themed_gratitude_journal/u_weekly_topics"}>
        Start using <strong> Edit current weekly topic</strong>
      </.b_link>
    </div>
    """
  end
end
