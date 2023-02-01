defmodule OurExperienceWeb.Auth.Ueberauth.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  alias Ueberauth.Auth
  alias OurExperience.Users.Users

  def find_or_create(%Auth{provider: :identity} = auth) do
    dbg(["miro in find_or_create 1", auth])

    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth) do
    dbg(["miro in find_or_create 2", auth])
    {:ok, basic_info(auth)}
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn(auth.provider <> " needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp basic_info(auth) do
    email = auth |> Map.get(:info) |> Map.get(:email)

    # user_from_db = Users.get_user_by_email(email)

    # if (!user_from_db) do
    #   case Users.create_user(email)  do
    #     {:ok, _new_user} ->
    #       dbg("user #{email} created")
    #       # user_from_db = new_user
    #     error -> dbg(["error creating user:", error])
    #   end
    # else
    #   dbg "user #{email} already exists"
    # end
    # # %{id: auth.uid, name: name_from_auth(auth), avatar: avatar_from_auth(auth), email: email}
    # %{email: email}

    user = if String.contains?(email, "@") do
      get_or_create_user_from_valid_email(email)
    else
      dbg ["expected to get an email as a string but got:", email]
      nil
    end

    # dbg(["miromm", user])
    # %{id: auth.uid, name: name_from_auth(auth), avatar: avatar_from_auth(auth), email: email}
    user
  end

  defp get_or_create_user_from_valid_email(email) do
    user_from_db = Users.get_user_by_email(email)
      if !user_from_db do
        case Users.create_user(email) do
          {:ok, new_user} ->
            dbg("user #{email} created")
            new_user

          error ->
            dbg(["error creating user:", error])
            nil
        end
      else
        dbg(["user retrieved from database: ", user_from_db])
        user_from_db
      end
  end

  # defp name_from_auth(auth) do
  #   if auth.info.name do
  #     auth.info.name
  #   else
  #     name = [auth.info.first_name, auth.info.last_name]
  #     |> Enum.filter(&(&1 != nil and &1 != ""))

  #     cond do
  #       length(name) == 0 -> auth.info.nickname
  #       true -> Enum.join(name, " ")
  #     end
  #   end
  # end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
