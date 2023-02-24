defmodule OurExperienceWeb.Pages.GratitudeJournal.Journal.Journal do
  # use Phoenix.Component
  # use Phoenix.LiveComponent
  use OurExperienceWeb, :live_view
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
  alias Phoenix.Socket

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries,
    as: JEs

  # alias Phoenix.LiveView.JS
  on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns

  @impl true
  def mount(_params, _session, socket) do
    send(socket.parent_pid, {:joural_liveview_pid, self()})
    dbg(["bbbbb", socket.assigns])

    socket = assign(socket, wait_for_parent_assigns: true)

    {:ok, socket}
  end

  # @impl true
  # # def update(%{current_user: u} = assigns, socket) do
  # def update(assigns, socket) do
  #   {:ok, socket}
  # end

  defp pushJE(socket, item) do
    push_event(socket, "existingJournalEntryFromServer", %{
      existingJE: Jason.encode!(%{id: item.id, content: item.content})
    })
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div :if={@wait_for_parent_assigns} class="text-center mt-11">loading...</div>
    <div :if={!@wait_for_parent_assigns} id="my_journal_wrapper">
      <.hiddenModalTriggers />
      <h1>My Journal</h1>

      <%!-- button to view modal of current active weekly topic --%>
      <div class="flex justify-center">
        <.b_link to={~p"/my_experience/strategies/themed_gratitude_journal/u_weekly_topics/"}>
          All Weekly Themes ->
        </.b_link>
        <.button phx-click={show_modal("current_weekly_topic")} type="button">
          <p>Current theme -></p>
          <p class="text-xs">(<%= @current_weekly_topic.title %>)</p>
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
          <div id="editor_for_new_journal_entry" />
          <%!-- id="journal_entry" to link js event to this live component --%>
        </div>
        <div class="relative">
          <div class="flex items-center justify-center w-full">
            <.button class="m-1" phx-click="saveNewJE">
              Save
            </.button>
            <.button class="m-1" phx-click="saveNewJEWithoutReload">
              Save without reload
            </.button>
            <span class={"absolute right-0 transition duration-700 #{if @saving_state_to_display=="saved", do: "opacity-100", else: "opacity-0"}"}>
              Saved :-)
            </span>
          </div>
        </div>
      </div>

      <div id="existing_journal_entries_wrapper">
        <h2>History</h2>

        <div :for={existing_JE <- @journals} class="existing_journal_entry_wrapper">
          <%!-- <p><%= existing_JE.id %></p> --%>
          <p>Date: <%= existing_JE.inserted_at %></p>
          <div id={"content_of_existing_journal_entry_id_#{existing_JE.id}"} phx-update="ignore" />
          <div class="existingJEoptions">
            <%!-- <.button phx-click="showEditJEModal" value={existing_JE.id} > --%>
            <.button phx-click="showEditJEModal" phx-value-id={existing_JE.id}>
              Edit
            </.button>
            <.button phx-click="showDeleteJEModal" phx-value-id={existing_JE.id}>
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
              JS.push("saveExistingJE")
              |> hide_modal("modal_for_existing_journal_entry_to_edit")
            }
            class="confirm_action_button"
          >
            Save changes
          </.button>
        </.modal>
        <.modal id="modal_for_existing_journal_entry_to_delete">
          <div class="miroQuillWrapper" id="wrapper_for_quill_in_delete_modal" phx-update="ignore">
            <div class="miroQuillContainer" />
          </div>
          <.button
            phx-click={
              JS.push("deleteExistingJEFinal")
              |> hide_modal("modal_for_existing_journal_entry_to_delete")
            }
            class="confirm_action_button"
          >
            confirm Delete
          </.button>
        </.modal>
      </div>
      <div id="editor_trigger" phx-hook="TextEditor" />
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
  def handle_event("showEditJEModal", %{"id" => id}, socket) do
    # def handle_event("showEditJEModal", %{"value" => id}, socket) do
    #  id = String.to_integer(id)

    socket =
      socket
      |> push_event("existingJournalEntryIdForEditModalFromServer", %{id: id})

    {:noreply, socket}
  end

  def handle_event("saveExistingJE", %{"je_id_to_edit" => id}, socket) do
    id = String.to_integer(id)
    dbg(["saveExistingJE", id])

    editedJE = socket.assigns.edited_quill

    origEntry =
      journals(socket.assigns.user)
      |> JEs.L.get_JE_by_id(id)

    if !editedJE || editedJE.id != id do
      dbg(["saveExistingJE", "ERROR - ids do not match. journal entry NOT SAVED"])
      {:noreply, socket}
    else
      dbg(editedJE)
      {:noreply, updateExistingJEAndSocket(socket, origEntry, editedJE)}
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

    {:noreply, socket}
  end

  # DATA ******************************************************************
  @impl true
  def handle_event(
        "text-editor",
        %{"text_content" => content, "journalEntryId" => id} = _att,
        socket
      ) do
    dbg(["handle text-editor   --> receiving quill data from UI ", id, content])
    # id = String.to_integer(id)
    # dbg [socket.assigns[:edited_quill]]

    socket = assign(socket, :saving_state_to_display, "saving...")

    # case id do
    #   # this is a new JE
    #   nil ->
    #     socket = assign(socket, quill: content)
    #     case socket.assigns[:newJE] do
    #       # this new JE was not yet saved
    #       nil ->
    #         _socket = createNewJEAndUpdateSocketWithoutReload(socket)
    #       je ->
    #         _socket = updateNewJEAndSocketWithoutReload(socket, je, content)
    #     end
    #   id ->
    #     socket
    #     |> assign(edited_quill: %{id: String.to_integer(id), content: content})
    # end
    newJE = socket.assigns[:newJE]

    socket =
      cond do
        # this is a new JE
        id == nil && newJE == nil ->
          _socket = createNewJEAndUpdateSocketWithoutReload(socket, content)

        id == nil && newJE != nil ->
          _socket = updateNewJEAndSocketWithoutReload(socket, newJE, content)

        id != nil ->
          socket |> assign(edited_quill: %{id: String.to_integer(id), content: content})
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
    {:noreply, createNewJEAndUpdateSocketAndList(socket)}
  end

  def handle_event("saveNewJEWithoutReload", _params, socket) do
    dbg(["handle save, don't update list ", socket.assigns.quill])

    socket = push_event(socket, "getLatestQillDataOfNewQuill", %{})

    # socket = createNewJEAndUpdateSocketWithoutReload(socket)

    # distinguish if new JE was already saved; if yes, update

    # case socket.assigns.newJE do
    #   nil ->
    #     # createJE
    #     nil

    #   je ->
    #     nil
    #     # updateJE
    # end

    {:noreply, socket}
  end

  # private ******************************************************************
  defp createNewJEAndUpdateSocketAndList(socket) do
    case JEs.create_in(strategy(socket.assigns.user), %{content: socket.assigns.quill}) do
      {:ok, newJE} ->
        user = socket.assigns.user
        dbg("journal entry SAVED")
        # u = dbUser(socket)
        # update user localy
        u = update_user_journals_localy(user, [newJE | journals(user)])

        socket
        |> put_flash(:info, "Journal entry created successfully")
        |> push_event("existingJournalEntrySaved_clearContent", %{})
        |> assign(:user, u)
        |> assign(:newJE, nil)
        |> assign(:journals, journals(u))
        |> ForSocket.addFromListToSocket([newJE], &pushJE/2)

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg("ERROR - journal entry NOT SAVED")

        socket
        |> put_flash(:error, "Journal entry not saved.")
        |> assign(:changeset, changeset)
    end
  end

  # @spec createNewJEAndUpdateSocketWithoutReload(Socket.t()) :: Socket.t()
  defp createNewJEAndUpdateSocketWithoutReload(socket, content) do
    dbg("createNewJEAndUpdateSocketWithoutReload")

    socket =
      case JEs.create_in(strategy(socket.assigns.user), %{content: content}) do
        {:ok, newJE} ->
          dbg("journal entry SAVED")
          Process.send_after(self(), {:saving_state_to_display, nil}, 1_000)

          assign(socket, :newJE, newJE)
          |> assign(:saving_state_to_display, "saved")

        {:error, %Ecto.Changeset{} = changeset} ->
          dbg("ERROR - journal entry NOT SAVED")

          socket
          |> put_flash(:error, "Journal entry not saved.")
          |> assign(:changeset, changeset)
          |> assign(:saving_state_to_display, "failed saving!!")
      end

    # socket2 = Map.update!(socket, :assigns, fn assigns -> Map.delete(assigns, :flash) end)
    # socket = Map.update!(socket, :assigns, fn assigns -> Map.put(assigns, :flash, nil) end)
    # socket2 = assign(socket, :saving_state_to_display, "saved")

    # dbg(["ssss", Map.keys(socket.assigns)])

    # send_update_after(
    #   # OurExperienceWeb.Pages.GratitudeJournal.Journal.Journal,
    #   __MODULE__,
    #   # socket2.assigns,
    #   [id: "journal", saving_state_to_display: "saved"],
    #   2000
    # )
    # send(socket.parent_pid, {:joural_liveview_pid, self()})

    socket
  end

  defp updateNewJEAndSocketWithoutReload(socket, origEntry, updatedContent) do
    dbg("updateNewJEAndSocketWithoutReload")

    case JEs.update_u__journal__entry(origEntry, %{content: updatedContent}) do
      {:ok, _updatedJE} ->
        Process.send_after(self(), {:saving_state_to_display, nil}, 1_000)

        socket
        |> assign(:saving_state_to_display, "saved")

      # |> assign(:newJE, updatedJE)
      # |> ForSocket.addFromListToSocket([updatedJE], &pushJE/2)

      {:error, %Ecto.Changeset{} = _changeset} ->
        dbg("ERROR - journal entry NOT SAVED")

        socket
        |> put_flash(:error, "Journal entry not saved.")
    end
  end

  defp updateExistingJEAndSocket(socket, origEntry, editedJE) do
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

        socket
        |> put_flash(:info, "Journal entry edited successfully")
        |> assign(:user, u)
        |> assign(:journals, journals(u))
        |> ForSocket.addFromListToSocket([updatedJE], &pushJE/2)

      {:error, %Ecto.Changeset{} = _changeset} ->
        dbg("ERROR - journal entry NOT SAVED")

        socket
        |> put_flash(:error, "Journal entry not saved.")
    end
  end

  defp update_user_journals_localy(user, newJournals) do
    str = put_in(strategy(user)[:u_journal_entries], newJournals)
    # returns updated user
    put_in(user[:u_strategies], [str])
  end

  defp strategy(user) do
    U.gj_strategy(user)
  end

  defp journals(nil), do: nil

  defp journals(user) do
    dbg(["journals f running", user[:id]])
    strategy(user)[:u_journal_entries]
  end

  # defp dbUser(socket) do
  #   Users.get_user_for_TGJ(socket.assigns.user.id)
  # end

  @impl true
  def handle_info({:assigns_from_parent, parent_assigns}, socket) do
    dbg(["assigns_from_parent - keys:", Map.keys(parent_assigns)])
    u = parent_assigns[:current_user]

    socket =
      socket
      # |> assign(assigns)
      |> ForSocket.addFromListToSocket(journals(u), &pushJE/2)
      |> assign(:journals, journals(u))
      |> assign(:user, u)
      |> assign(:quill, nil)
      |> assign(:newJE, nil)
      |> assign(:edited_quill, nil)
      # TODO:
      |> assign(:saving_state_to_display, nil)
      |> assign(:current_weekly_topic, U_Strategy.current_weekly_topic(strategy(u)))
      |> assign(wait_for_parent_assigns: false)

    {:noreply, socket}
  end

  #    Process.send_after(self(), {:saving_state_to_display, nil}, 1_000)

  def handle_info({:saving_state_to_display, value}, socket) do
    dbg(["handle_info saving_state_to_display: ", value])
    socket = assign(socket, :saving_state_to_display, value)
    {:noreply, socket}
  end
end
