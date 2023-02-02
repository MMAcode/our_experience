defmodule OurExperienceWeb.WeeklyTopicLive.FormComponent do
  use OurExperienceWeb, :live_component

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopics
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage weekly_topic records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="weekly_topic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label="title" />
        <.input
          field={{f, :summary}}
          type="textarea"
          style="overflow:scroll; min-height:20vh"
          label="summary"
        />
        <.input
          field={{f, :introduction}}
          type="textarea"
          style="overflow:scroll; min-height:20vh"
          label="introduction"
        />
        <.input
          field={{f, :content}}
          type="textarea"
          style="overflow:scroll; min-height:50vh"
          label="content"
        />
        <.input
          field={{f, :day_by_day_instructions}}
          type="textarea"
          style="overflow:scroll; min-height:20vh"
          label="day_by_day_instructions"
        />
        <.input field={{f, :default_position}} type="number" label="default_position" />
        <.input field={{f, :default_active_status}} type="checkbox" label="default_active_status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Weekly topic</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{weekly_topic: weekly_topic} = assigns, socket) do
    changeset = WeeklyTopics.change_weekly_topic(weekly_topic)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"weekly_topic" => weekly_topic_params}, socket) do
    changeset =
      socket.assigns.weekly_topic
      |> WeeklyTopics.change_weekly_topic(weekly_topic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"weekly_topic" => weekly_topic_params}, socket) do
    save_weekly_topic(socket, socket.assigns.action, weekly_topic_params)
  end

  defp save_weekly_topic(socket, :edit, weekly_topic_params) do
    case WeeklyTopics.update_weekly_topic(socket.assigns.weekly_topic, weekly_topic_params) do
      {:ok, _weekly_topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Weekly topic updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_weekly_topic(socket, :new, weekly_topic_params) do
    case WeeklyTopics.create_weekly_topic(weekly_topic_params) do
      {:ok, _weekly_topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Weekly topic created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
