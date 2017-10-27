defmodule PlatformWeb.UserController do
  use PlatformWeb, :controller

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def update(conn, params) do
    new_name = params["user_name"]

    conn
    |> put_resp_cookie("user_name", new_name, max_age: 24 * 60 * 60)
    |> redirect(to: "/")
  end
end
