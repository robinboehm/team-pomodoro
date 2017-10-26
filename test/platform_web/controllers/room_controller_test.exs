defmodule PlatformWeb.RoomControllerTest do
  use PlatformWeb.ConnCase

  alias Platform.Core

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get conn, room_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Rooms"
    end
  end

end
