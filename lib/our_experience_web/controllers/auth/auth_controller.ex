defmodule OurExperienceWeb.Auth.AuthController do
  alias OurExperienceWeb.Auth.Ueberauth.UserFromAuth
  use OurExperienceWeb, :controller
  plug Ueberauth

  def logout(conn, _params) do
    # dbg(["mm logout f1.:", Application.loaded_applications()], printable_limit: :infinity, limit: :infinity) #get names of all apps
    # dbg(["mm logout f2.:", Application.get_all_env(:ueberauth)], printable_limit: :infinity, limit: :infinity) #get all env vars in specific app
    # dbg(["mm logout f2.:", Application.get_all_env(:our_experience)], printable_limit: :infinity, limit: :infinity) #get all env vars in specific app
    # dbg(["mm logout f3.:", Application.get_env(:ueberauth, Ueberauth.Strategy.Auth0.OAuth)], printable_limit: :infinity, limit: :infinity)
    auth0_secrets = Application.get_env(:ueberauth, Ueberauth.Strategy.Auth0.OAuth)

    # endpoint = Application.get_env(:our_experience, OurExperienceWeb.Endpoint)[:url][:host] |> dbg
    return_url = Application.get_env(:our_experience, Miro)[:logout_url]
    query = %{
      "returnTo" => return_url,
      "client_id" => auth0_secrets[:client_id]
    }
    encoded_query = URI.encode_query(query)
    url = "https://#{auth0_secrets[:domain]}/v2/logout?#{encoded_query}" |> dbg


    conn
    # |> Session.logout()
    |> configure_session(drop: true)
    |> clear_session()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(external: url)

    # conn
    # |> configure_session(drop: true)
    # |> clear_session()
    # |> put_flash(:info, "You have been logged out!")
    # |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    dbg("miro123")

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    dbg(["miro12", conn])

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
