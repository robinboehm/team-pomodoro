defmodule PlatformWeb.RoomController do
  use PlatformWeb, :controller

  alias Platform.Core
  alias Platform.Core.Schema.Room

  def index(conn, _params) do
    rooms = Core.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def show(conn, %{"id" => id}) do
    room = Core.get_room!(id)
    render(conn, "show.html", room: room)
  end

end
