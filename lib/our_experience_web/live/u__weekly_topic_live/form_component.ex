defmodule OurExperienceWeb.U_WeeklyTopicLive.FormComponent do
  use OurExperienceWeb, :live_component

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage u__weekly_topic records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="u__weekly_topic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :position}} type="number" label="position" />
        <.input field={{f, :active}} type="checkbox" label="active" />
        <:actions>
          <.button phx-disable-with="Saving...">Save U  weekly topic</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{u__weekly_topic: u__weekly_topic} = assigns, socket) do
    changeset = U_WeeklyTopics.change_u__weekly_topic(u__weekly_topic)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"u__weekly_topic" => u__weekly_topic_params}, socket) do
    changeset =
      socket.assigns.u__weekly_topic
      |> U_WeeklyTopics.change_u__weekly_topic(u__weekly_topic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"u__weekly_topic" => u__weekly_topic_params}, socket) do
    save_u__weekly_topic(socket, socket.assigns.action, u__weekly_topic_params)
  end

  defp save_u__weekly_topic(socket, :edit, u__weekly_topic_params) do
    case U_WeeklyTopics.update_u__weekly_topic(
           socket.assigns.u__weekly_topic,
           u__weekly_topic_params
         ) do
      {:ok, _u__weekly_topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "U  weekly topic updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_u__weekly_topic(socket, :new, u__weekly_topic_params) do
    case U_WeeklyTopics.create_u__weekly_topic(u__weekly_topic_params) do
      {:ok, _u__weekly_topic} ->
        {:noreply,
         socket
         |> put_flash(:info, "U  weekly topic created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
