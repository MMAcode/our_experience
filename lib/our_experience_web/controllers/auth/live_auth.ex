defmodule OurExperienceWeb.Auth.AuthForLive do # auth for live  page (wrapped in live_session)
  import Phoenix.Component    # for assign(); this methodd was moved from \Phoenix.LiveView to here in 0.18.0

  # live hook for welcome_live
  def on_mount(:matchThis, params, session, socket) do
    dbg(["on_mount welcome", params, session, socket],
      printable_limit: :infinity,
      limit: :infinity
    )

    assign_current_user(socket, session, "Outer")
    # {:cont, socket}
  end

  def on_mount(:matchThisInner, params, session, socket) do
    dbg(["on_mount welcome", params, session, socket],
      printable_limit: :infinity,
      limit: :infinity
    )

    assign_current_user(socket, session, "Inner")
    # {:cont, socket}
  end

  defp assign_current_user(socket, _session, nameEnd) do # assign current user from session to socket
    {:cont,
     assign(socket,
       current_user: %{name: "live-plug - dummyUser_fromAuthForLive_" <> nameEnd}
      #  csrf_token: "MiroDummyCs"   # this does not have any effect
     )}

    # case session do
    #   %{current_user: user} ->
    #     # {:noreply, assign(socket, :current_user, user)}
    #     assign(socket, :current_user, user)
    #   _ ->
    #     {:noreply, assign(socket, :current_user, nil)}
    # end
  end
end
