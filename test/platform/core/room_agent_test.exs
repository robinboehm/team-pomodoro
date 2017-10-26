defmodule Platform.RoomAgentTest do
  use ExUnit.Case, async: true

  alias Platform.Core.RoomAgent

  setup do
    {:ok, room} = start_supervised(RoomAgent)
    %{room: room}
  end

  describe "#init" do
    test "should init the userlist with an empty list", %{room: room} do
      assert RoomAgent.list_users(room) == []
    end
  end

  describe "add_user" do
    test "should add a user to the current room", %{room: room} do
      assert RoomAgent.list_users(room) == []

      RoomAgent.add_user(room, %{})

      assert RoomAgent.list_users(room) == [%{}]
    end

    test "should add more than one user to the current room", %{room: room} do
      assert RoomAgent.list_users(room) == []

      RoomAgent.add_user(room, %{})
      RoomAgent.add_user(room, %{})

      assert RoomAgent.list_users(room) == [%{},%{}]
    end
  end

end
