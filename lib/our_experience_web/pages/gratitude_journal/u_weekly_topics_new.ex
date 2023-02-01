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
  alias Phoenix.LiveView.JS
    on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns


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
    socket = socket
    |> assign(:counter, 0)
    |> assign(:rerender?, true)
    |> assign(:show_modal, false)
    |> assign(:clicked_topic, nil)
    |> assign(:test, nil)
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
      <%!-- <.button type="button" phx-click="form-event2" phx-target={@myself} phx-value-topicidmiro={topic_form.data.id}>ahoj</.button> --%>
      <%!-- <.button type="button" phx-click="form-event2" phx-target={@myself} phx-value-topicidmiro={123}>ahoj</.button> --%>
      <%!-- <.button  phx-click="form-event2" phx-target={@myself}>ahoj2</.button> --%>
      <.form
        :let={f}
        for={@u_str_changeset}
        phx-change="form_event"
        phx-submit="save"
        phx-target={@myself}
      >
        <%!-- <.input field={{f, :title}} type="text" label="title" /> --%>

        <% topics_forms = inputs_for(f, :u_weekly_topics) %>
        <%!-- <% dbg Enum.at(topics_forms,0)%> --%>
        <%!-- <%= dbg is_list(topics_forms)%> --%>
        <%!-- <%= dbg f %> --%>
        <.button>Save</.button>

        <.table
        :if={@rerender? != nil} id="weekly_topics_new" rows={topics_forms}>
          <:col :let={topic_form} label="Title"><%= topic_form.data.weekly_topic.title %></:col>
          <:col :let={topic_form} label="Summary"><%= topic_form.data.weekly_topic.summary %></:col>
          <%!-- <:col :let={topic_form} label="Active?"><%= input_value(topic_form, :active)%></:col> --%>
          <:col :let={topic_form} label="Active?">
            <%= hidden_input(topic_form, :id) %>
            <%!-- <%= checkbox(topic_form, :active) %> --%>
            <.input field={{topic_form, :active}} type="checkbox" label="active?" />
          </:col>
          <:col :let={topic_form} label="View details">
          <%!-- <% dbg topic_form %> --%>
              <%!-- phx-click="toggle-modal" --%>
              <%!-- phx-click={JS.show(to: "#u-topic-modal")} --%>
              <%!-- phx-click={JS.show(to: "u-topic-modal")} --%>
              <%!-- phx-click="toggle-modal" --%>
            <.button
            phx-click={JS.push("toggle-modal") |> show_modal(topic_form.id)}
              type="button"
              phx-target={@myself}
              phx-value-topic-id={topic_form.data.weekly_topic.id}
            >
              View details
            </.button>
                  <.modal
      id={topic_form.id}
      >
      <%!-- on_cancel={JS.hide(to: "#u-topic-modal", transition: "fade-out")} --%>
        <p>lskj flwke fwle jflwk eflkw eflkwjf</p>
        <%!-- <% dbg @clicked_topic %> --%>
        <% dbg topic_form.data.weekly_topic.title %>
        <% wt = topic_form.data.weekly_topic %>
        <% dbg wt %>



        <p> a:<%= topic_form.data.weekly_topic.id %> </p>
        <p> b: <%= wt.id %> </p>
        <h3> title </h3>
        <p> <%= wt.title%> </p>
        <h3> summary </h3>
        <p> <%= wt.summary%> </p>
        <h3> content </h3>
        <p> <%= wt.content%> </p>
        <h3> day_by_day_instructions </h3>
        <p> <%= wt.day_by_day_instructions%> </p>
        <p>xxx <%= @test %>yyy</p>
      </.modal>
          </:col>
        </.table>
      </.form>
      <%!-- phx-mounted={JS.transition("animate-ping", time: 500)} --%>
      <%!-- :if={@show_modal|>dbg} --%>
      <%!-- :if={@counter > 0} --%>
      <%!-- show={@show_modal|>dbg} --%>
<%!-- show={true}} --%>

    </div>
    """
  end


  #   def handle_event("toggle-modal", attr, socket) do
  #   dbg ["toggle-modal event triggered", attr]
  #   {:noreply, socket}
  # end

  def handle_event("toggle-modal", %{"topic-id" => topic_id}, socket) do
    #
    u_str_changeset = socket.assigns.u_str_changeset
    # dbg(topic_id)
    # dbg(u_str_changeset.data)

    topic = U_Strategy.get_weekly_topic_by_topic_id_from_loaded_data(u_str_changeset.data, String.to_integer(topic_id))
    # dbg topic
    socket = socket
    |> assign(:show_modal, true)
    |> assign(:counter, (socket.assigns.counter) + 1)
    |> assign(:test, "ahoj")
    |> assign(:clicked_topic, topic)

    {:noreply, socket}
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
      {:ok, _u_strategy} ->
        dbg(["saved"])

      # {:noreply, socket}
      {:error, _changeset} ->
        dbg("error")
        # {:noreply, assign(socket, u_str_changeset: changeset)
    end

    {:noreply, socket}
  end
end

# ARCHIVE:
# def handle_event("form_event", %{"u__strategy" => %{"u_weekly_topics" => u_weekly_topics} = u_strategy_params} = params, socket) do
#   changed_position =  Enum.at(params["_target"],2)

#   updated_u_weekly_topics = Enum.map(u_weekly_topics, fn {key, map} ->
#     updated_map = if (key == changed_position),
#     do: Map.put(map, "active", "true"),
#     else: Map.put(map, "active", "false")
#     updated_map = Map.put(updated_map, "counter", socket.assigns.counter+1)

#     {key, updated_map} end) |> Enum.into(%{})
#   updated_u_strategy_params = Map.put(u_strategy_params, "u_weekly_topics", updated_u_weekly_topics)

#   dbg(["form params", params])
#   dbg(updated_u_strategy_params)

#   original_u_strategy = socket.assigns.u_str_changeset.data
#   updated_u_str_changeset = U_Strategy.changeset(original_u_strategy, updated_u_strategy_params)
#   # updated_u_str_changeset = U_Strategy.changeset(original_u_strategy, u_strategy_params)
#   dbg updated_u_str_changeset

#   socket =   assign(socket, u_str_changeset: updated_u_str_changeset)
#   socket =   assign(socket, :counter, socket.assigns.counter + 1)
#   socket =   assign(socket, :rerender?, !socket.assigns.rerender?)
#   {:noreply, socket}
# end

# <.form :let={f} for={@u_str_changeset} phx-change="form_event" phx-submit="save" phx-target={@myself}>
#   <%!-- <.input field={{f, :title}} type="text" label="title" /> --%>

#   <% topics_forms = inputs_for(f, :u_weekly_topics) %>
#   <%!-- <% dbg Enum.at(topics_forms,0)%> --%>
#   <%!-- <%= dbg is_list(topics_forms)%> --%>
#   <%!-- <%= dbg f %> --%>
#   <.button>Save</.button>

#   <.table :if={(@rerender? !=nil)} id="weekly_topics_new" rows={topics_forms}>
#     <:col :let={topic_form} label="Title">
#     <%!-- <% dbg(topic_form) %> --%>
#     <%= topic_form.id %>
#     <%= input_value(topic_form, :active)%>
#     <%= %>
#     </:col>
#     <%!-- <:col :let={topic_form} label="Title"><%= topic.weekly_topic.title %></:col> --%>
#     <%!-- <:col :let={topic_form} label="Summary"><%= topic.weekly_topic.summary %></:col> --%>
#     <:col :let={topic_form} label="Active">
#     <%!-- <button type="button" phx-click="ahoj" phx-target={@myself}>ahoj</button> --%>
#       <%!-- <%= topic.weekly_topic.summary %> --%>
#       <%= hidden_input(topic_form, :id) %>
#       <%!-- <%= checkbox(topic_form, :active) %> --%>
#       <% dbg topic_form %>
#       <.button type="button" phx-click="form_event" phx-target={@myself} phx-value-topic-id={topic_form.data.id} ><%= if input_value(topic_form, :active), do: "SELECTED", else: "select" %></.button>

#       <%!-- <%= radio_button(topic_form, :active, true, checked: input_value(topic_form, :active)) %> --%>
#       <%!-- <%= hidden_input(topic_form, :position) %>  --%>
#       <%!-- <%= hidden_input(topic_form, :counter) %> --%>
#       <.input
#         field={{topic_form, :active}}
#         type="radio"
#         label="active?"
#         checked={(input_value(topic_form, :active))|>dbg}
#       />
#         <%!-- value={input_value(topic_form, :active)} --%>

#       <%!-- <.input
#         field={{topic_form, :active}}
#         type="checkbox"
#         label="active?"
#       /> --%>
#         <%!-- value={input_value(topic_form, :active)} --%>
#         <%!-- checked={input_value(topic_form, :active)} --%>
#        <%!-- id={input_id(topic_form, :id)} --%>
#        <%!-- <% dbg topic_form %> --%>

#        <%!-- checked={input_value(topic_form, :active)} --%>
#        <%!-- checked-value="true" --%>
#        <%!-- unchecked_value="false" --%>
#        <%!-- unchecked_value="false" --%>
#        <%!-- value={input_value(topic_form, :active)|> dbg}> --%>

#         <%!-- value={input_value(topic_form, :active)|>dbg} --%>
#         <%!-- name={input_name(f, :u_weekly_topics)<> "[][active]"} --%>
#     </:col>
#   </.table>
# </.form>

# <.button
# type="button"
# phx-click="form_event"
# phx-target={@myself}
# phx-value-topic-id={topic_form.data.id} >
#   <%= if input_value(topic_form, :active), do: "SELECTED", else: "select" %>
# </.button>

#                  <.input
#   field={{topic_form, :active}}
#   type="checkbox"
#   label="active?"
#   disabled={if (is_binary(value)), do: String.to_atom(value), else: value}
#   value={value}
# />
