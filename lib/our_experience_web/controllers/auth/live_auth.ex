defmodule OurExperienceWeb.Auth.LiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component # for assign()

  def on_mount(:matchThis, _params, session, socket) do
      assign_current_user(socket, session)
  end

  defp assign_current_user(socket, _session) do
    {:cont, assign(socket, :current_user, %{name: "dummyUser_fromLiveAuth"})}

    # case session do
    #   %{current_user: user} ->
    #     # {:noreply, assign(socket, :current_user, user)}
    #     assign(socket, :current_user, user)
    #   _ ->
    #     {:noreply, assign(socket, :current_user, nil)}
    # end
  end
end
