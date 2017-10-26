defmodule PlatformWeb.PageController do
  use PlatformWeb, :controller

  def index(conn, _params) do
    redirect conn, to: room_path(conn, :index)
  end
end
