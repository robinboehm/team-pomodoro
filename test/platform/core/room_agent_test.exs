defmodule Platform.RoomAgentTest do
  use ExUnit.Case, async: true

  alias Platform.Core.RoomAgent

  setup do
    {:ok, room} = start_supervised(RoomAgent)
    %{room: room}
  end

  describe "add_user" do
    test "adds a user to the current room", %{room: room} do
      assert RoomAgent.list_users(room) == []

      RoomAgent.add_user(room, %{})

      assert RoomAgent.list_users(room) == [%{}]
    end

    test "adds more than one user to the current room", %{room: room} do
      assert RoomAgent.list_users(room) == []

      RoomAgent.add_user(room, %{})
      RoomAgent.add_user(room, %{})

      assert RoomAgent.list_users(room) == [%{},%{}]
    end
  end

end
