defmodule Platform.RoomRegistryTest do
  use ExUnit.Case, async: true

  alias Platform.Core.RoomRegistry
  alias Platform.Core.RoomAgent

  import Platform.Core.RoomRegistry

  setup do
    {:ok, registry} = start_supervised RoomRegistry
    %{registry: registry}
  end

  test "spawns rooms", %{registry: registry} do
    assert lookup(registry, "room-uuid-1") == :error

    create(registry, "room-uuid-1")
    assert {:ok, room} = lookup(registry, "room-uuid-1")

    assert RoomAgent.list_users(room) == []
    RoomAgent.add_user(room, %{})
    assert RoomAgent.list_users(room) == [%{}]
  end

  test "only create an RoomAgent-instance per name once", %{registry: registry} do
    first_room = create(registry, "room-uuid-1")
    same_room = create(registry, "room-uuid-1")

    assert first_room == same_room
  end

  test "create an RoomAgent-instance per name", %{registry: registry} do
    first_room = create(registry, "room-uuid-1")
    second_room = create(registry, "room-uuid-2")

    assert first_room != second_room
  end

  test "removes a RoomAgent-instance when it crashes", %{registry: registry} do
    create(registry, "room-uuid-1")
    assert {:ok, room} = lookup(registry, "room-uuid-1")

    Agent.stop(room)

    assert lookup(registry, "room-uuid-1") == :error
  end

end
