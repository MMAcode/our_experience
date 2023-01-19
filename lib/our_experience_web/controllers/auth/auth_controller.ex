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

    # ueberauth_auth: %Ueberauth.Auth{
    #     uid: "google-oauth2|110722583238847144647",
    #     provider: :auth0,
    #     strategy: Ueberauth.Strategy.Auth0,
    #     info: %Ueberauth.Auth.Info{
    #       name: "Miroslav Makarov",
    #       first_name: "Miroslav",
    #       last_name: "Makarov",
    #       nickname: "miroslav.makarov",
    #       email: "miroslav.makarov@gmail.com",
    #       location: nil,
    #       description: nil,
    #       image: "https://lh3.googleusercontent.com/a/AEdFTp735vTUemsSP1MyJiSjp6n7hb3dqCYY8RcQYzMBUkg=s96-c",
    #       phone: nil,
    #       birthday: nil,
    #       urls: %{profile: nil, website: nil}

    # ueberauth_auth: %Ueberauth.Auth{
    #     uid: "auth0|63b60ba0cb240538d9e86fa1",
    #     provider: :auth0,
    #     strategy: Ueberauth.Strategy.Auth0,
    #     info: %Ueberauth.Auth.Info{
    #       name: "miroslav.makarov@gmail.com",
    #       first_name: nil,
    #       last_name: nil,
    #       nickname: "miroslav.makarov",
    #       email: "miroslav.makarov@gmail.com",
    #       location: nil,
    #       description: nil,
    #       image: "https://s.gravatar.com/avatar/f0a49c301321756b2731cb040799c8ec?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fmi.png",
    #       phone: nil,
    #       birthday: nil,
    #       urls: %{profile: nil, website: nil}
    #     },

    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        dbg(user)

        conn
        # |> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        |> put_session(:current_user, user)
        # |> configure_session(renew: true)
        |> redirect(to: "/my_experience")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
