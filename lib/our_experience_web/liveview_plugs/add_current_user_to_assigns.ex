defmodule OurExperienceWeb.LiveviewPlugs.AddCurrentUserToAssigns do
  import Phoenix.Component
  # import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    {:cont, assign(socket, :current_user, Map.get(session, "current_user"))}
  end
end
