defmodule OurExperienceWeb.Pages.GratitudeJournal.UWeeklyTopicsNew do
  # use Phoenix.Component
  use Phoenix.LiveComponent
  # for text_input
  import Phoenix.HTML.Form
  import OurExperienceWeb.CoreComponents
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.U_Strategies.U_Strategies

  # when here, user already has an active TGJ strategy
  # def mount(%{assigns: %{current_user: user}} = socket) do
  def mount(socket) do
    # dbg(socket)
    # dbg "mounr123"
    # dbg. socket

    # dbg TGJ.get_active_TGJ_uStrategy(user)
    {:ok, socket}
  end

  def update(%{current_user: user} = assigns, socket) do
    u_strategy = TGJ.get_active_TGJ_uStrategy(user)
    u_str_changeset = U_Strategy.changeset(u_strategy)

    socket = assign(socket, assigns) |> assign(:u_str_changeset, u_str_changeset)
    # dbg socket.assigns.u_str_changeset.data
    # dbg socket
    {:ok, socket}
  end

  def render(assigns) do
    # def index(assigns) do
    # dbg(["NEW", assigns])

    ~H"""
    <div>
      <h1>Your Weekly topics (new)</h1>

      <%!-- <div :for={topic <- @topics}>
      <.topic title={topic.weekly_topic.title} summary={topic.weekly_topic.summary} />
    </div> --%>
      <%!-- <.simple_form --%>
      <.button phx-click="ahoj" phx-target={@myself}>ahoj</.button>

      <.form :let={f} for={@u_str_changeset} phx-change="form_event" phx-submit="save" phx-target={@myself}>
        <%!-- <.input field={{f, :title}} type="text" label="title" /> --%>

        <% topics_forms = inputs_for(f, :u_weekly_topics) %>
        <%!-- <% dbg Enum.at(topics_forms,0)%> --%>
        <%!-- <%= dbg is_list(topics_forms)%> --%>
        <%!-- <%= dbg f %> --%>
        <.button>Save</.button>
        <.table id="weekly_topics_new" rows={topics_forms}>
          <:col :let={topic_form} label="Title">
          <%!-- <% dbg(topic_form) %> --%>
          <%= topic_form.id %>
          <%= input_value(topic_form, :active)%>
          <%= %>
          </:col>
          <%!-- <:col :let={topic_form} label="Title"><%= topic.weekly_topic.title %></:col> --%>
          <%!-- <:col :let={topic_form} label="Summary"><%= topic.weekly_topic.summary %></:col> --%>
          <:col :let={topic_form} label="Active">
            <%!-- <%= topic.weekly_topic.summary %> --%>
            <%= hidden_input(topic_form, :id) %>
            <.input
              field={{topic_form, :active}}
              type="checkbox"
              label="active?"
            />
              <%!-- name={input_name(f, :u_weekly_topics)<> "[][active]"} --%>
          </:col>
        </.table>
      </.form>
    </div>
    """
  end

  def topic(assigns) do
    ~H"""
    <tr>
      <td>Title: <%= @title %></td>
      <td>Summary: <%= @summary %></td>
    </tr>
    """
  end

  # def handle_event("ahoj", _params, socket) do
  #   dbg(1234)
  #   {:noreply, socket}
  # end

  # def handle_event("email_changed", _params, socket) do
  #   dbg(111)
  #   {:noreply, socket}
  # end

  def handle_event("form_event", %{"u__strategy" => u_strategy_params} = _params, socket) do
    # dbg(["form params", params])
    # dbg(u_strategy_params)

    original_u_strategy = socket.assigns.u_str_changeset.data
    updated_u_str_changeset = U_Strategy.changeset(original_u_strategy, u_strategy_params)

    dbg updated_u_str_changeset

    {:noreply, assign(socket, u_str_changeset: updated_u_str_changeset)}
  end

  def handle_event("save",%{"u__strategy" => u_strategy_params} = _params, socket) do
    dbg "saving"

    case U_Strategies.update_u__strategy(socket.assigns.u_str_changeset.data, u_strategy_params) do
      {:ok, u_strategy} ->
        dbg ["saved", u_strategy]
        # {:noreply, socket}
      {:error, _changeset} ->
        dbg "error"
        # {:noreply, assign(socket, u_str_changeset: changeset)
    end



    {:noreply, socket}
  end
end
