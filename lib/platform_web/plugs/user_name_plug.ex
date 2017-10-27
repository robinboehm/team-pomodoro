defmodule PlatformWeb.UserNamePlug do
  @moduledoc """
  Reads the user name from the cookie.
  Sets a random if none exists
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    if conn.cookies["user_name"] do
      conn
    else
      random_name = Haikunator.build(0, " ")

      conn
      |> put_resp_cookie("user_name", random_name, max_age: 24*60*60)
    end
  end
end
