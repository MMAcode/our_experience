defmodule OurExperienceWeb.Pages.GratitudeJournal.Journal.Journal do
  # use Phoenix.Component
  use Phoenix.LiveComponent
  # to be able to use ~p sigil:
  use OurExperienceWeb, :live_view
  # for text_input
  import Phoenix.HTML.Form
  import OurExperienceWeb.CoreComponents
  import OurExperienceWeb.MiroComponents
  import OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.U_Strategies.U_Strategies
  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries
  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{current_user: user} = assigns, socket) do
    u_strategy = TGJ.get_active_TGJ_uStrategy(user)

    socket =
      socket
      |> assign(assigns)
      |> assign(:u_TGJ_strategy, u_strategy)
      |> assign(
        :current_weekly_topic,
        U_Strategy.get_current_weekly_topic_from_loaded_data(u_strategy)
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%!-- <% dbg(@u_TGJ_strategy.data) %> --%>
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

      <%!-- <new_journal_entry_component /> --%>
      <%!-- <.form
        :let={f}
        for={@u_TGJ_strategy}
        phx-change="form_event"
        phx-submit="save"
        phx-target={@myself}
      >
        <.text_input f={f} field="journal_entry" />
        <.button type="submit">Save</.button>
        <.button phx-click="cancel" type="button">Cancel</.button>
      </.form> --%>
      <div id="editorWrapper" phx-update="ignore">
        <h3 id="journal_entry">Add new journal entry</h3> <%!-- id="journal_entry" to link js event to this live component --%>
        <div id="editor" phx-hook="TextEditor" phx-target={@myself}/>
      </div>
      <.button phx-click="save"
      phx-disable-with="Saving..."
      phx-target={@myself}>Save</.button>

      <%!-- Exiting journal entries --%>
    </div>
    """
  end

  @impl true
  def handle_event("text-editor", %{"text_content" => content}, socket) do
    dbg(content)
    {:noreply, assign(socket, quill: content)}
  end

  def handle_event("save", _params, socket) do
    dbg(["handle save", socket.assigns.quill])
    u_str = socket.assigns.u_TGJ_strategy.data


    case U_Journal_Entries.create_in(u_str, %{content: socket.assigns.quill}) do
      {:ok, saved_quill} ->
        dbg "journal entry SAVED"
        {:noreply,
          socket
          |> put_flash(:info, "Journal entry created successfully")
          # |> assign(:quills, [saved_quill | socket.assigns.quills])
          |> assign(:quills, saved_quill)
        }
        {:error, %Ecto.Changeset{} = changeset} ->
          dbg "ERROR - journal entry NOT SAVED"

          {:noreply,
          socket
          |> put_flash(:error, "Journal entry not saved.")
          |> assign(:changeset, changeset)
          }
    end
    # {:noreply, socket}
  end

end
