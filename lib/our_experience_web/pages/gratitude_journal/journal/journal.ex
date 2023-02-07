defmodule OurExperienceWeb.Pages.GratitudeJournal.Journal.Journal do
  # use Phoenix.Component
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS
  use OurExperienceWeb, :verified_routes
  # to be able to use ~p sigil:
  # use OurExperienceWeb, :live_view
  # for text_input
  # import Phoenix.HTML.Form
  import OurExperienceWeb.CoreComponents
  import OurExperienceWeb.MiroComponents
  alias OurExperience.Users.Users
  import OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent
  import OurExperienceWeb.Pages.GratitudeJournal.Journal.UJournalEntryModalComponent
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Utilities.ForSocket

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries

  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{current_user: user} = assigns, socket) do
    u_strategy = TGJ.get_active_TGJ_uStrategy_fromLoadedData(user)
    journals = u_strategy[:u_journal_entries]

    socket =
      socket
      |> ForSocket.addFromListToSocket(journals, &pushJE/2)
      |> assign(assigns)
      |> assign(:u_strategy, u_strategy)
      |> assign(:journals, journals)
      |> assign(:user, user)
      |> assign(:quill, nil)
      |> assign(:edited_quill, nil)
      |> assign(
        :current_weekly_topic,
        U_Strategy.get_current_weekly_topic_from_loaded_data(u_strategy)
      )

    {:ok, socket}
  end

  defp pushJE(socket, item) do
    push_event(socket, "existingJournalEntryFromServer", %{
      existingJE: Jason.encode!(%{id: item.id, content: item.content})
    })
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="my_journal_wrapper">
      <h1>My Journal</h1>
      <%!-- button to view modal of current active weekly topic --%>
      <div class="flex justify-center">
        <.b_link to={~p"/my_experience/strategies/themed_gratitude_journal/u_weekly_topics/"}>
          Themes ->
        </.b_link>
        <.button phx-click={show_modal("current_weekly_topic")} type="button" phx-target={@myself}>
          Current theme ->
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
          <h3 id="new_journal_entry">Add new journal entry</h3>
          <%!-- id="journal_entry" to link js event to this live component --%>
          <div id="editor" phx-hook="TextEditor" phx-target={@myself} />
        </div>
        <.button phx-click="saveNewJE" phx-target={@myself}>
          Save
        </.button>
        <%!-- phx-disable-with="Saving..."  --%>
      </div>

      <div id="existing_journal_entries_wrapper">
        <h2>History</h2>
        <div :for={existing_JE <- @journals} class="existing_journal_entry_wrapper">
          <%!-- <p><%= existing_JE.id %></p> --%>
          <p>Date: <%= existing_JE.inserted_at %></p>
          <div id={"content_of_existing_journal_entry_id_#{existing_JE.id}"} />
          <div class="existingJEoptions">
            <.button phx-click={
              JS.push("showEditJEModal", value: %{id: existing_JE.id}, target: @myself)
              |> show_modal("modal_for_existing_journal_entry_to_edit")
            }>
              Edit
            </.button>

            <.button phx-click={
              JS.push("showDeleteJEModal", value: %{id: existing_JE.id}, target: @myself)
              |> show_modal("modal_for_existing_journal_entry_to_delete")
            }>
              Delete
            </.button>
          </div>
        </div>
        <.modal id="modal_for_existing_journal_entry_to_edit">
          <div class="miroQuillWrapper" id="wrapper_for_quill_in_editing_modal" phx-update="ignore">
            <div class="miroQuillContainer" />
          </div>
          <.button
            phx-click={
              JS.push("editExistingJEFinal")
              |> hide_modal("modal_for_existing_journal_entry_to_edit")
            }
            phx-target={@myself}
            class="confirm_action_button"
          >
            Save changes
          </.button>
        </.modal>
        <.modal id="modal_for_existing_journal_entry_to_delete">
          <div class="miroQuillContainer" />
          <.button
            phx-click={
              JS.push("deleteExistingJEFinal")
              |> hide_modal("modal_for_existing_journal_entry_to_delete")
            }
            phx-target={@myself}
            class="confirm_action_button"
          >
            confirm Delete
          </.button>
        </.modal>
      </div>
    </div>
    """
  end

  def handle_event("showEditJEModal", %{"id" => id}, socket) do
    # dbg(["editExistingJE", id])

    socket =
      socket
      |> push_event("existingJournalEntryIdForEditModalFromServer", %{id: id})

    {:noreply, socket}
  end

  # def handle_event("editExistingJEFinal", %{})

  def handle_event("showDeleteJEModal", %{"id" => id}, socket) do
    # dbg(["showDeleteJEModal", id])

    socket =
      socket
      |> push_event("existingJournalEntryIdForDeleteModalFromServer", %{id: id})

    {:noreply, socket}
  end

  def handle_event("deleteExistingJEFinal", %{"je_id_to_delete" => id}, socket) do
    id = String.to_integer(id)
    # dbg(["deleteExistingJEFinal", id])

    socket =
      case U_Journal_Entries.delete_using_id(id) do
        {1, _} ->
          dbg("deleted ok")
          put_flash(socket, :info, "deleted")

        x ->
          dbg(["issue deleting JE with id", id, "error?:", x])
          put_flash(socket, :error, "error")
      end

    # dbg(socket)
    user = Users.get_user_for_TGJ(socket.assigns.user.id)
    u_strategy = TGJ.get_active_TGJ_uStrategy_fromLoadedData(user)
    journals = u_strategy[:u_journal_entries]

    socket =
      socket
      |> assign(:u_strategy, u_strategy)
      |> assign(:journals, journals)
      # to improve: only push deleted je update?
      |> ForSocket.addFromListToSocket(journals, &pushJE/2)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "text-editor",
        %{"text_content" => content, "journalEntryId" => id} = _att,
        socket
      ) do
    dbg(["handle text-editor", id, content])
    # dbg [socket.assigns[:edited_quill]]
    socket =
      case id do
        # new JE edited
        nil -> assign(socket, quill: content)
        id -> socket |> assign(edited_quill: %{id: id, content: content})
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("existingJE_as_text", %{"text_content" => content}, socket) do
    dbg(content)
    # socket = socket
    # |> assign(:existingJES_as_text, )
    {:noreply, socket}
  end

  def handle_event("saveNewJE", _params, socket) do
    dbg(["handle save", socket.assigns.quill])
    u_str = socket.assigns.u_strategy

    case U_Journal_Entries.create_in(u_str, %{content: socket.assigns.quill}) do
      {:ok, _saved_quill} ->
        dbg("journal entry SAVED")

        {
          :noreply,
          socket
          |> put_flash(:info, "Journal entry created successfully")
          # |> assign(:quills, [saved_quill | socket.assigns.quills])
          #  |> assign(:quills, saved_quill)}
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg("ERROR - journal entry NOT SAVED")

        {:noreply,
         socket
         |> put_flash(:error, "Journal entry not saved.")
         |> assign(:changeset, changeset)}
    end

    # {:noreply, socket}
  end

  def handle_event("editExistingJEFinal", %{"je_id_to_edit" => id}, socket) do
    id = String.to_integer(id)
    dbg(["editExistingJEFinal", id])

    editedJE = socket.assigns.edited_quill
    origEntry = U_Strategy.get_journal_entry_by_id_from_loaded_data(socket.assigns.u_strategy, id)

    if !editedJE || editedJE.id != id do
      dbg(["editExistingJEFinal", "ERROR - ids do not match. journal entry NOT SAVED"])
      {:noreply, socket}
    else
      dbg(editedJE)
      U_Journal_Entries.update_u__journal__entry(origEntry, %{content: editedJE.content})

      # case  do
      #   {:ok, _} ->
      #     dbg("journal entry SAVED")

      #     {:noreply,
      #      socket
      #      |> put_flash(:info, "Journal entry edited successfully")
      #      |> assign(:quills, editedJE)}

      #   {:error, %Ecto.Changeset{} = changeset} ->
      #     dbg("ERROR - journal entry NOT SAVED")

      #     {:noreply,
      #      socket
      #      |> put_flash(:error, "Journal entry not saved.")
      #      |> assign(:changeset, changeset)}
      # end
    end

    {:noreply, socket}
  end
end
