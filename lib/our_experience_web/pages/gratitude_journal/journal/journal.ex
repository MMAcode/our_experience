defmodule OurExperienceWeb.Pages.GratitudeJournal.Journal.Journal do
  # use Phoenix.Component
  use Phoenix.LiveComponent
  use OurExperienceWeb, :verified_routes
  # to be able to use ~p sigil:
  # use OurExperienceWeb, :live_view
  # for text_input
  # import Phoenix.HTML.Form
  import OurExperienceWeb.CoreComponents
  import OurExperienceWeb.MiroComponents
  import OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Utilities.RichTextEditors.Quill.Quill

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries

  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(socket) do
    # push_event(socket, "miroFromServer", %{savedQuills: ["ahoj"]})
    {:ok, socket}
  end

  @impl true
  def update(%{current_user: user} = assigns, socket) do
    u_strategy = TGJ.get_active_TGJ_uStrategy(user)

    socket =
      socket
      |> addToSocket(u_strategy[:u_journal_entries])
      |> assign(assigns)
      |> assign(:u_strategy, u_strategy)
      |> assign(
        :current_weekly_topic,
        U_Strategy.get_current_weekly_topic_from_loaded_data(u_strategy)
      )

    {:ok, socket}
  end

  def addToSocket(socket, [el | tail]) do
    socket =
      push_event(socket, "miroFromServer", %{
        existingJE: Jason.encode!(%{id: el.id, content: el.content})
      })

    addToSocket(socket, tail)
  end

  def addToSocket(socket, []), do: socket


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%!-- <% dbg(@u_strategy.data) %> --%>
      <h1>My Journal</h1>
      <%!-- button to view modal of current active weekly topic --%>
      <div class="flex justify-center">
        <.button phx-click={show_modal("current_weekly_topic")} type="button" phx-target={@myself}>
          View current weekly topic
        </.button>
        <.weekly_topic_modal_component id="current_weekly_topic" weekly_topic={@current_weekly_topic}>
          <div class="flex justify-center">
            <.b_link to={~p"/my_experience/strategies/themed_gratitude_journal/u_weekly_topics"}>
              <strong> Select different topic</strong>
            </.b_link>
          </div>
        </.weekly_topic_modal_component>
      </div>

      <div id="new_journal_entry_wrapper">
        <div id="editorWrapper" phx-update="ignore">
          <h3 id="journal_entry">Add new journal entry</h3>
          <%!-- id="journal_entry" to link js event to this live component --%>
          <div id="editor" phx-hook="TextEditor" phx-target={@myself} />
        </div>
        <.button phx-click="save" phx-disable-with="Saving..." phx-target={@myself}>Save</.button>
      </div>
      <div id="existing_journal_entries_wrapper">
        <h2>History</h2>

        <div
          :for={existing_JE <- @u_strategy[:u_journal_entries]}
          class="existing_journal_entry_wrapper"
        >
          <%!-- <p><%= existing_JE.id %></p> --%>
          <p>Date: <%= existing_JE.inserted_at %></p>
          <div id={"content_of_existing_journal_entry_id_#{existing_JE.id}"}>c</div>
          <%!-- <p><%= Quill.printable_quill(existing_JE.content) %></p> --%>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("text-editor", %{"text_content" => content}, socket) do
    dbg(content)
    {:noreply, assign(socket, quill: content)}
  end

  @impl true
  def handle_event("existingJE_as_text", %{"text_content" => content}, socket) do
    dbg(content)
    # socket = socket
    # |> assign(:existingJES_as_text, )
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    dbg(["handle save", socket.assigns.quill])
    u_str = socket.assigns.u_strategy.data

    case U_Journal_Entries.create_in(u_str, %{content: socket.assigns.quill}) do
      {:ok, saved_quill} ->
        dbg("journal entry SAVED")

        {:noreply,
         socket
         |> put_flash(:info, "Journal entry created successfully")
         # |> assign(:quills, [saved_quill | socket.assigns.quills])
         |> assign(:quills, saved_quill)}

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg("ERROR - journal entry NOT SAVED")

        {:noreply,
         socket
         |> put_flash(:error, "Journal entry not saved.")
         |> assign(:changeset, changeset)}
    end

    # {:noreply, socket}
  end
end
