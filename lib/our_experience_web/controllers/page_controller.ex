defmodule OurExperienceWeb.PageController do
  use OurExperienceWeb, :controller

  def home(conn, _params) do
    dbg(["page controller conn assigns", conn.assigns])
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
