defmodule OurExperienceWeb.RichTextEditors.Quill do
  use OurExperienceWeb, :live_view
  #   on_mount OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns
  alias OurExperience.RichTextStorageRepo

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true -> connected_mount(socket)
      false -> {:ok, assign(socket, page: "loading", quills: [], quill: nil, count: 0)}
    end
  end

  def connected_mount(socket) do
    quills = printable_quills(list_quills())
    push_event(socket, "miroFromServer", %{savedQuills: quills})

    {:ok,
     assign(socket, quills: list_quills(), quill: nil, count: 0, page: "connected")
     #  |> push_event("miroFromServer", %{savedQuills: nil})}
     |> push_event("miroFromServer", %{savedQuills: quills})}
  end

  @impl true
  def render(%{page: "loading"} = assigns) do
    ~H"""
    <p>Loading...</p>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet" /> --%>
    <h1>Page 4</h1>
    <h2>Quill</h2>

    <%!-- <div id="editor" phx-hook="TextEditor" phx-target={@myself} /> --%>
    <h3>Existing:</h3>
    <%= for row <- printable_quills(@quills) do %>
      <div><%= row %></div>
    <% end %>

    <%!-- <script> --%>
    <%!-- miroPost = <%= Jason.encode!(getQuill(@quills, 2)) %>; --%>
    <%!-- </script> --%>
    <h3>Add new:</h3>
    <%!-- commeted out to avoid possible troubles with non-unique IDs. --%>
    <div id="editorWrapper1" phx-update="ignore"><%!--to persist editor accross liveview changes --%>
      <div id="editor" phx-hook="TextEditor"/></div>
    <.button phx-click="save" phx-disable-with="Saving...">Save</.button>
    """
  end

  @impl true
  def handle_event("text-editor", %{"text_content" => content}, socket) do
    dbg(content)
    {:noreply, assign(socket, quill: content)}
  end

  def handle_event("save", _params, socket) do
    dbg(["handle save", socket.assigns.quill])
    save_quill(socket)
  end

  defp save_quill(socket) do
    dbg("saving quill")

    case OurExperience.RichTextStorageRepo.create(%{data: socket.assigns.quill}) do
      {:ok, saved_quill} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Just map created successfully")
          |> assign(:quills, [saved_quill | socket.assigns.quills])
          #  |> push_navigate(to: socket.assigns.navigate)
          # |> push_event("miroFromServer", %{id: "miroId"})
          # |> fn x -> dbg(["miro 125", x], printable_limit: :infinity, limit: :infinity); x end.()
          # |> (fn x ->
          # dbg(["miro 1256jm", saved_quill], printable_limit: :infinity, limit: :infinity)
          # x
          # end).()
          # |> push_event("miroFromServer", %{savedQuills: saved_quill.data})
        }

      # {:noreply, push_event(socket, "highlight", %{id: "item-#{item.id}"})}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp list_quills do
    dbg("calling db")
    RichTextStorageRepo.list_all()
  end

  defp printable_quills(quills) do
    quills
    |> Enum.map(fn row -> Jason.encode!(row.data) end)
  end

  # defp getQuill(listX, id) do
  #   listX
  #   |> Enum.filter(&(&1.id == id))
  #   |> Enum.map(fn row -> row.data end)
  # end
end
