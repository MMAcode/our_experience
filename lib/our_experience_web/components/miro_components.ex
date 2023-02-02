defmodule OurExperienceWeb.MiroComponents do
  use Phoenix.Component
  import OurExperienceWeb.CoreComponents

  # minimum level to view this content
  attr :minimum_admin_level, :integer, default: 1000

  slot :inner_block
  attr :current_user, :map, required: true

  def admin_level(assigns) do
    current_user_admin_level =
      case assigns[:current_user][:admin_level] do
        nil -> 0
        level -> level
      end

    if current_user_admin_level >= assigns[:minimum_admin_level] do
      ~H"""
      <%!-- <div style="background-color:yellow"> --%>
      <div class="bg-yellow-200 p-2">
        <p class="text-gray-500 text-sm text-center">Admin section</p>
        <%= render_slot(@inner_block) %>
      </div>
      """
    else
      ~H"""

      """
    end
  end

  # <.b_link to={~p""}></.b_link>
  def b_link(assigns) do
    ~H"""
    <%!-- # <.link navigate={~p"/strategies/themed_gratitude_journal/"}> --%>
    <.link navigate={@to}>
      <.button><%= render_slot(@inner_block) %></.button>
    </.link>
    """
  end
end
