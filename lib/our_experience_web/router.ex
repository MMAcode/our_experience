defmodule OurExperienceWeb.Router do
  use OurExperienceWeb, :router
  require Ueberauth
  alias OurExperienceWeb.Auth.LiveAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {OurExperienceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user_or_nil
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OurExperienceWeb do
    pipe_through :browser
    live "/", Pages.WelcomeLive
    get "/orig", PageController, :home
  end

  live_session :dummy,
    root_layout: {OurExperienceWeb.Layouts, :root},
    on_mount: {LiveAuth, :matchThis} do
    live "/li", OurExperienceWeb.Pages.WelcomeLive
    # live "/li", Pages.WelcomeLive, :edit
    # live "/cohorts/new", CohortsLive.Index, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", OurExperienceWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:our_experience, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OurExperienceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/auth", OurExperienceWeb.Auth do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    get "/logout", AuthController, :logout
  end

  def secure(conn, _params) do
    user = get_session(conn, :current_user)
    dbg(user)

    case user do
      nil ->
        conn
        |> redirect(to: "/auth/auth0")
        # |> fn x -> dbg(["miro025", x]); x end.()
        |> halt

      _ ->
        dbg(user)
        assign(conn, :current_user, user)
    end
  end

  def fetch_current_user_or_nil(conn, _opts) do
    user = get_session(conn, :current_user)
    userName = if user, do: user.name, else: ""
    dbg(userName)

    assign(conn, :current_user, user)
    |> (fn x ->
          dbg(["miro25", x.assigns])
          x
        end).()
  end
end
