defmodule OurExperienceWeb.Router do
  use OurExperienceWeb, :router
  require Ueberauth
  alias OurExperienceWeb.Auth.AuthForLive
  # alias OurExperienceWeb.RichTextEditors.Quill

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {OurExperienceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OurExperienceWeb.Auth.CSRFtokenFix
    plug :fetch_current_user_or_nil
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

    #  get "/orig", OurExperienceWeb.PageController, :home   # probably not allowed 'out of scope'
  scope "/", OurExperienceWeb do
    pipe_through :browser
    live "/", Pages.WelcomeLive  # does pipe through plugs
    get "/orig", PageController, :home
  end

  scope "/private", OurExperienceWeb do
    pipe_through [:browser, :secure]
    live "/", Pages.WelcomePrivateLiveNoSession  # does pipe through plugs
    live "/quill", RichTextEditors.Quill
  end

  scope "/admin", OurExperienceWeb do
    pipe_through [:browser, :secure, :admin_only]
    live "/weekly_topics", WeeklyTopicLive.Index, :index
    live "/weekly_topics/new", WeeklyTopicLive.Index, :new
    live "/weekly_topics/:id/edit", WeeklyTopicLive.Index, :edit
    live "/weekly_topics/:id", WeeklyTopicLive.Show, :show
    live "/weekly_topics/:id/show/edit", WeeklyTopicLive.Show, :edit
end

  scope "/live" do #live but not session
   pipe_through :browser
   live "/ls", OurExperienceWeb.Pages.WelcomeLive
  end

  live_session :dummy,
    root_layout: {OurExperienceWeb.Layouts, :root},
    # root_layout: {OurExperienceWeb.Layouts, :app},
    on_mount: {AuthForLive, :matchThis}
    do
    # pipe_through :browser

    live "/ls", OurExperienceWeb.Pages.WelcomeLive
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

    # delete "/logout", AuthController, :logout
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  def secure(conn, _params) do
    user = get_session(conn, :current_user)
    dbg(["secure plug running; user from conn.session:", user])

    case user do
      nil -> to_auth(conn)
      _ ->
        assign(conn, :current_user, user)
    end
  end

  def admin_only(conn, _params) do
    case conn.assigns[:current_user][:admin_level] do
      nil ->
            dbg ["admin_only f :current_user:", conn.assigns[:current_user]]
            to_auth(conn)
      level -> if level < 1000, do: to_home(conn), else: conn
    end
  end

  defp to_auth(conn) do
        conn
        |> redirect(to: "/auth/auth0")
        |> halt
  end

  defp to_home(conn) do
        conn
        |> redirect(to: "/")
        |> halt
  end

  def fetch_current_user_or_nil(conn, _opts) do
    dbg(["fetch_current_user_or_nil plug running; user from conn.session: ", get_session(conn, :current_user)])
    user = get_session(conn, :current_user)
    assign(conn, :current_user, user)
  end

end
