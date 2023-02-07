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
  alias OurExperience.Users.User, as: U
  import OurExperienceWeb.Pages.GratitudeJournal.WeeklyTopicModalComponent
  import OurExperienceWeb.Pages.GratitudeJournal.Journal.UJournalEntryModalComponent
  # import Phoenix.LiveView.Helpers #probably already imported but just in case...
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate, as: TGJ
  alias OurExperience.U_Strategies.U_Strategy
  alias OurExperience.Utilities.ForSocket

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries,
    as: JEs

  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{current_user: u} = assigns, socket) do
    socket =
      socket
      |> ForSocket.addFromListToSocket(journals(u), &pushJE/2)
      |> assign(assigns)
      |> assign(:journals, journals(u))
      |> assign(:user, u)
      |> assign(:quill, nil)
      |> assign(:edited_quill, nil)
      |> assign(
        :current_weekly_topic,
        U_Strategy.current_weekly_topic(strategy(u))
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
    <.hiddenModalTriggers />
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
          <div id={"content_of_existing_journal_entry_id_#{existing_JE.id}"} phx-update="ignore" />
          <div class="existingJEoptions">
            <.button phx-click="showEditJEModal" value={existing_JE.id} phx-target={@myself}>
              Edit
            </.button>
            <.button phx-click="showDeleteJEModal" phx-value-id={existing_JE.id} phx-target={@myself}>
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

  defp hiddenModalTriggers(assigns) do
    ~H"""
    <div
      style="hidden"
      id="hiddenTriggerForViewingEditModal"
      miro-js-to-trigger={show_modal("modal_for_existing_journal_entry_to_edit")}
    />
    <div
      style="hidden"
      id="hiddenTriggerForViewingDeleteModal"
      miro-js-to-trigger={show_modal("modal_for_existing_journal_entry_to_delete")}
    />
    """
  end

  # EDIT  ******************************************************************
  # def handle_event("showEditJEModal", %{"id" => id}, socket) do
  def handle_event("showEditJEModal", %{"value" => id}, socket) do
    # dbg att
    # dbg(["editExistingJE", id])

    socket =
      socket
      |> push_event("existingJournalEntryIdForEditModalFromServer", %{id: id})

    {:noreply, socket}
  end

  def handle_event("editExistingJEFinal", %{"je_id_to_edit" => id}, socket) do
    id = String.to_integer(id)
    dbg(["editExistingJEFinal", id])

    editedJE = socket.assigns.edited_quill

    origEntry =
      journals(socket.assigns.user)
      |> JEs.L.get_JE_by_id(id)

    if !editedJE || editedJE.id != id do
      dbg(["editExistingJEFinal", "ERROR - ids do not match. journal entry NOT SAVED"])
      {:noreply, socket}
    else
      dbg(editedJE)

      case JEs.update_u__journal__entry(origEntry, %{content: editedJE.content}) do
        {:ok, updatedJE} ->
          dbg(["journal entry UPDATED", updatedJE])
          # u = dbUser(socket)
          user = socket.assigns.user

          newJournals =
            Enum.map(journals(user), fn je ->
              if je.id == updatedJE.id, do: updatedJE, else: je
            end)

          u = update_user_journals_localy(user, newJournals)

          {:noreply,
           socket
           |> put_flash(:info, "Journal entry edited successfully")
           |> assign(:user, u)
           |> assign(:journals, journals(u))
           |> ForSocket.addFromListToSocket([updatedJE], &pushJE/2)}

        {:error, %Ecto.Changeset{} = changeset} ->
          dbg("ERROR - journal entry NOT SAVED")

          {:noreply,
           socket
           |> put_flash(:error, "Journal entry not saved.")}
      end
    end

    # {:noreply, socket}
  end

  # DELETE ******************************************************************
  def handle_event("showDeleteJEModal", %{"id" => id}, socket) do
    # dbg(["showDeleteJEModal", id])

    socket =
      socket
      |> push_event("existingJournalEntryIdForDeleteModalFromServer", %{id: id})

    {:noreply, socket}
  end

  def handle_event(
        "deleteExistingJEFinal",
        %{"je_id_to_delete" => id},
        %{assigns: %{user: user}} = socket
      ) do
    id = String.to_integer(id)

    socket =
      case JEs.delete_using_id(id) do
        {1, _} ->
          dbg("deleted ok")
          u = update_user_journals_localy(user, journals(user) |> Enum.filter(&(&1.id != id)))

          socket
          |> put_flash(:info, "deleted")
          |> assign(:user, u)
          |> assign(:journals, journals(u))

        x ->
          dbg(["issue deleting JE with id", id, "error?:", x])
          put_flash(socket, :error, "error")
      end

    # u = dbUser(socket)

    # socket =
    #   socket
    #   |> assign(:user, u)
    #   |> assign(:journals, journals(u))

    {:noreply, socket}
  end

  # DATA ******************************************************************
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

  # NEW ******************************************************************
  def handle_event("saveNewJE", _params, socket) do
    dbg(["handle save", socket.assigns.quill])

    case JEs.create_in(strategy(socket.assigns.user), %{content: socket.assigns.quill}) do
      {:ok, newJE} ->
        user = socket.assigns.user
        dbg("journal entry SAVED")
        # u = dbUser(socket)
        # update user localy
        u = update_user_journals_localy(user, [newJE | journals(user)])

        {
          :noreply,
          socket
          |> put_flash(:info, "Journal entry created successfully")
          |> assign(:user, u)
          |> assign(:journals, journals(u))
          |> ForSocket.addFromListToSocket([newJE], &pushJE/2)
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

  # private ******************************************************************
  defp update_user_journals_localy(user, newJournals) do
    str = put_in(strategy(user)[:u_journal_entries], newJournals)
    # returns updated user
    put_in(user[:u_strategies], [str])
  end

  defp strategy(user) do
    U.gj_strategy(user)
  end

  defp journals(user) do
    strategy(user)[:u_journal_entries]
  end

  defp dbUser(socket) do
    Users.get_user_for_TGJ(socket.assigns.user.id)
  end
end
