defmodule OurExperienceWeb.Pages.GratitudeJournal.UWeeklyTopicsNew do
  # use Phoenix.Component
  use Phoenix.LiveComponent
  # for text_input
  import Phoenix.HTML.Form
  import OurExperienceWeb.CoreComponents
  import OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.U_Strategies.U_Strategies
  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  # when here, user already has an active TGJ strategy
  # def mount(%{assigns: %{current_user: user}} = socket) do
  def mount(socket) do
    {:ok, socket}
  end

  def update(%{current_user: user} = assigns, socket) do
    u_strategy = TGJ.get_active_TGJ_uStrategy(user)

    socket =
      socket
      |> assign(assigns)
      |> assign(:u_str_changeset, U_Strategy.changeset(u_strategy))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Your Weekly topics</h1>
      <h3>(At least one topic must be active!)</h3>
      <.form
        :let={f}
        for={@u_str_changeset}
        phx-change="form_event"
        phx-submit="save"
        phx-target={@myself}
      >
        <.button>Save</.button>
        <.table id="weekly_topics_new" rows={_topics_forms = inputs_for(f, :u_weekly_topics)}>
          <:col :let={topic_form} label="Title"><%= topic_form.data.weekly_topic.title %></:col>
          <:col :let={topic_form} label="Summary"><%= topic_form.data.weekly_topic.summary %></:col>
          <:col :let={topic_form} label="Active?">
            <%= hidden_input(topic_form, :id) %>
            <.input field={{topic_form, :active}} type="checkbox" label="active?" />
          </:col>
          <:col :let={topic_form} label="View details">
            <.button
              phx-click={show_modal(topic_form.id)}
              type="button"
              phx-target={@myself}
              phx-value-topic-id={topic_form.data.weekly_topic.id}
            >
              View details
            </.button>
            <.weekly_topic_modal_component
              id={topic_form.id}
              weekly_topic={topic_form.data.weekly_topic}
            />
          </:col>
        </.table>
      </.form>
    </div>
    """
  end

  def handle_event("form_event", %{"u__strategy" => u_strategy_params}, socket) do
    dbg(u_strategy_params)
    original_u_strategy = socket.assigns.u_str_changeset.data
    updated_u_str_changeset = U_Strategy.changeset(original_u_strategy, u_strategy_params)
    dbg(updated_u_str_changeset)
    socket = assign(socket, u_str_changeset: updated_u_str_changeset)
    {:noreply, socket}
  end

  def handle_event("save", %{"u__strategy" => u_strategy_params} = _params, socket) do
    dbg(["to save", u_strategy_params])

    case U_Strategies.update_u__strategy(socket.assigns.u_str_changeset.data, u_strategy_params) do
      {:ok, _u_strategy} -> dbg(["saved"])
      {:error, _changeset} -> dbg("error")
    end

    {:noreply, socket}
  end
end
