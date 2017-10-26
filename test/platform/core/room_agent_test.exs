defmodule Platform.RoomAgentTest do
  use ExUnit.Case, async: true

  alias Platform.Core.RoomAgent

  import Platform.Core.RoomAgent

  doctest Platform.Core.RoomAgent

  setup do
    {:ok, room} = start_supervised(RoomAgent)
    %{room: room}
  end

  describe "#init" do
    test "should init the userlist with an empty list", %{room: room} do
      assert list_users(room) == []
    end
  end

  describe "add_user" do
    test "should add a user to the current room", %{room: room} do
      assert list_users(room) == []

      add_user(room, %{})

      assert list_users(room) == [%{}]
    end

    test "should add more than one user to the current room", %{room: room} do
      assert list_users(room) == []

      add_user(room, %{})
      add_user(room, %{})

      assert list_users(room) == [%{},%{}]
    end
  end

  describe "#list_users" do
    test "should return the curent userlist", %{room: room} do
      assert list_users(room) == []

      assert list_users(room) == []
      add_user(room, %{})
      assert list_users(room) == [%{}]
    end
  end

  describe "remove_user" do
    test "should remove a user from the current room", %{room: room} do
      add_user(room, %{id: 1})
      add_user(room, %{id: 2})
      assert list_users(room) == [%{id: 2}, %{id: 1}]

      remove_user(room, 2)

      assert list_users(room) == [%{id: 1}]
    end

    test "should add more than one user to the current room", %{room: room} do
      assert list_users(room) == []

      add_user(room, %{})
      add_user(room, %{})

      assert list_users(room) == [%{},%{}]
    end
  end


end
