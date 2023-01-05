defmodule OurExperienceWeb.Auth.AuthController do
  alias OurExperienceWeb.Auth.Ueberauth.UserFromAuth
  use OurExperienceWeb, :controller
  plug Ueberauth

  def logout(conn, _params) do
    dbg "miro1234"
    conn
    |> configure_session(drop: true)
    |> clear_session()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    dbg "miro123"
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    dbg ["miro12",conn]
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        |> put_session(:current_user, user)
        # |> configure_session(renew: true)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
