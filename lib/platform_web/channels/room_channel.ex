defmodule PlatformWeb.RoomChannel do
  @moduledoc """
  The RoomChannel for socket communitcation in the context of a room
  """
  use PlatformWeb, :channel

  alias Platform.Presence
  alias Platform.Core.RoomTimer

  def join("room:lobby", _payload, socket) do
      {:ok, socket}
  end

  def join("room:" <> room_id , _payload, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.name, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("start", payload, socket) do
    # broadcast socket, "shout", payload
    RoomTimer.start()
    {:noreply, socket}
  end

  def handle_in("stop", payload, socket) do
    # broadcast socket, "shout", payload
    RoomTimer.stop()
    {:noreply, socket}
  end

  def handle_in("reset", payload, socket) do
    # broadcast socket, "shout", payload
    RoomTimer.reset()
    {:noreply, socket}
  end
end
