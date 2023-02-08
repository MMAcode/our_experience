defmodule OurExperienceWeb.ExtraComponents.ButtonComponents do
  # use Constellation, :live_component
  use Phoenix.LiveComponent

  @moduledoc """
    <.section title="Shiny new buttons">
    New buttons taking advantage of Liveview 0.18 and TailwindCSS
    <.example_group>
      <.example title="Default">
        <Constellation.ButtonComponents.button text="Test me" />
      </.example>
      <.example title="Stays done">
        <Constellation.ButtonComponents.button text="Test me" done_text="Different done text" stay_done />
      </.example>
      <.example title="Always loading">
        <Constellation.ButtonComponents.button text="Test me" loading loading_text="Always loading"/>
      </.example>
      <.example title="Shake user on click">
        <Constellation.ButtonComponents.button text={"This one is \"disabled\""} disabled />
      </.example>
    </.example_group>
  </.section>
  """




  @base_class "

  group
  p-4 m-4
  border-4 rounded
  bg-red-200
    radius-large text-center no-underline cursor-pointer inline-block select-none border-0
    pt-small pb-small pl-large pr-large rounded-large
    hover:no-underline hover:shadow-inset
    focus:outline-none focus:shadow-md
    active:shadow-inner
    disabled:bg-grey-lighter disabled:text-grey-light disabled:cursor-not-allowed disabled:shadow-none
    disabled:active:focus:shadow-none
    disabled:hover:focus:bg-grey-lighter disabled:hover:focus:text-grey-light disabled:hover:focus:shadow-none
  "

  @primary_class "
    text-green bg-green-400
    disabled:active:pointer-none
    hover:text-green-700
    active:text-red-800
  "

  @white_class "
    text-midnight bg-black
    disabled:active:pointer-none
    hover:text-midnight
    active:text-midnight
  "

  @subtle_class "
    text-indigo-blue border-2 border-indigo-blue bg-black
    hover:text-black hover:bg-indigo-blue hover:border-black
    active:text-white active:bg-indigo-blue active:border-white
  "

  @text_class "
    p-0 pt-small pb-small rounded
  "

  @danger_class "
    text-black bg-red inline-flex items-center
    hover:text-white
    active:text-white
  "

  @medium_class "text-tiny "

  @large_class "text-small "

  @shake_class "animate-wiggle "

  @icon_class "ml-tiny "
  @spinner_class "fa-light fa-circle-notch animate-spin "
  @checked_class "fa-light fa-check text-green "

  @impl true
  def mount(socket) do
    {:ok, assign(socket, shake: false)}
  end

  @impl true
  def update(assigns, socket) do
    if assigns[:done] && !assigns[:stay_done] do
      send_update_after(__MODULE__, [id: socket.assigns.id, done: false], 3000)
    end

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("btn-click", _, socket) do
    if socket.assigns.disabled do
      send_update_after(__MODULE__, [id: socket.assigns.id, shake: false], 1000)
      {:noreply, assign(socket, shake: true)}
    else
      # send(self(), {socket.assigns.click_event_key})
      send_update_after(__MODULE__, [id: socket.assigns.id, loading: false, done: true], 3000)
      {:noreply, assign(socket, loading: true)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <button
      class={variant_classes(@variant) <> size_classes(@size) <> shake_class(@shake) <> @class}
      phx-target={@myself}
      phx-click="btn-click"
    >
      <span :if={assigns[:text] && not @loading && not @done}><%= @text %></span>
      <span :if={@loading && not @done}><%= @loading_text %></span>
      <span :if={@done}><%= @done_text %></span>

      <%= if assigns[:inner_block] do %>
        <%= render_slot(@inner_block) %>
      <% end %>

      <span :if={@screenreader_text} class="sr-only"><%= @screenreader_text %></span>
      <i :if={@loading || @done} class={icon_classes(@loading, @done)} />
      <%= if (@loading && !@done) do  %>
      <p> LLLLL</p>
      <% end %>
    </button>
    """
  end

  defp variant_classes(:primary), do: @base_class <> @primary_class
  defp variant_classes(:white), do: @base_class <> @white_class
  defp variant_classes(:subtle), do: @base_class <> @subtle_class
  defp variant_classes(:danger), do: @base_class <> @danger_class
  defp variant_classes(:text), do: @base_class <> @text_class

  defp size_classes(:medium), do: @medium_class
  defp size_classes(:large), do: @large_class

  defp shake_class(true), do: @shake_class
  defp shake_class(_), do: ""

  defp icon_classes(_, true), do: @icon_class <> @checked_class
  defp icon_classes(true, _), do: @icon_class <> @spinner_class

  attr :id, :string, default: nil, doc: "Id for the button. Must be unique!"

  attr :variant, :atom,
    default: :primary,
    doc: """
      The variant of button to render.
      Options are :primary, :white, :text, :subtle, :danger
    """

  attr :size, :atom, default: :medium, doc: ":medium (default) or :large"

  attr :class, :string, default: "", doc: "Css classes to apply"

  attr :screenreader_text, :string, default: nil, doc: "Screenreader text for accessibility"

  attr :text, :string, doc: "The text to display in the button"

  attr :loading, :boolean, default: false, doc: "A flag to update the state of the button"

  attr :loading_text, :string,
    default: "Saving",
    doc: "The text to display when the button is in loading state"

  attr :done, :boolean,
    default: false,
    doc:
      "A flag to update the state of the button. Done state will be turned off by the button after 3 seconds if stay_done flag not provided."

  attr :stay_done, :boolean,
    default: false,
    doc: "When true, the button will not unset the done state"

  attr :done_text, :string,
    default: "Saved!",
    doc: "The text to display when the button is in done state"

  attr :click_event_key, :atom,
    default: :clicked,
    doc:
      "The event which will be triggered on user click of the button. This will be the key you subscribe to in handle_ifo/3 in the parent"

  attr :disabled, :boolean,
    default: false,
    doc:
      "Apparently nothing is ever disabled on the platform. Still that doesn't stop us from giving the user a shake when they try to interact with a disabled button!"

  slot :inner_block

  def button(assigns) do
    ~H"""
    <.live_component
      id={@id || "button-#{Atom.to_string(@variant)}-#{hash()}"}
      module={__MODULE__}
      {assigns}
    >
      <%= render_slot(@inner_block) %>
    </.live_component>
    """
  end

  defp hash do
    :crypto.strong_rand_bytes(8)
  end
end
