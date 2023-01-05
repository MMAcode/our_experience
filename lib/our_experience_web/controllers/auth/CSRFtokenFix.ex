defmodule OurExperienceWeb.Auth.CSRFtokenFix do
  import Plug.Conn, only: [put_session: 3]
  def init(_opts), do: nil
  def call(conn, _opts), do: put_session(conn, :csrf_token_fromCSRFtokenFix, Phoenix.Controller.get_csrf_token())
  # def call(conn, _opts), do: put_session(conn, :_csrf_token, Phoenix.Controller.get_csrf_token())   # not helping
end
