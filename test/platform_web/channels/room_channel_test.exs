defmodule PlatformWeb.RoomChannelTest do
  use PlatformWeb.ChannelCase

  alias PlatformWeb.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end
end
