defmodule PlatformWeb.RoomChannel do
  @moduledoc """
  The RoomChannel for socket communitcation in the context of a room
  """
  use PlatformWeb, :channel

  alias Platform.Presence

  def join("room:lobby", _payload, socket) do
      {:ok, socket}
  end

  def join("room:" <> room_id , _payload, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_info(:after_join, socket) do
    IO.inspect socket.topic
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
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
end
