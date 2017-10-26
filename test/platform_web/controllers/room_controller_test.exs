defmodule PlatformWeb.RoomControllerTest do
  use PlatformWeb.ConnCase

  alias Platform.Core

  @create_attrs %{name: "some name", uuid: "some uuid"}
  @update_attrs %{name: "some updated name", uuid: "some updated uuid"}
  @invalid_attrs %{name: nil, uuid: nil}

  def fixture(:room) do
    {:ok, room} = Core.create_room(@create_attrs)
    room
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get conn, room_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Rooms"
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    {:ok, room: room}
  end
end
