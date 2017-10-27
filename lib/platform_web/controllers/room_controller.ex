defmodule PlatformWeb.RoomController do
  use PlatformWeb, :controller

  alias Platform.Core

  def index(conn, _params) do
    rooms = Core.list_rooms()

    conn =
     conn
     |> put_resp_cookie("user_name", "second_cookie_value", max_age: 24*60*60)

    render(conn, "index.html", rooms: rooms)
  end

  def show(conn, %{"id" => id}) do
    room = Core.get_room!(id)

    render(conn, "show.html", room: room)
  end
end
