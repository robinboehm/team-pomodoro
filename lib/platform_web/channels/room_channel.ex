defmodule PlatformWeb.RoomChannel do
  @moduledoc """
  The RoomChannel for socket communitcation in the context of a room
  """
  use PlatformWeb, :channel

  alias Platform.Presence
  alias Platform.Core.TimerRegistry
  alias Platform.Core.Timer

  @endpoint PlatformWeb.Endpoint # move this to a config option

  def join("room:lobby", _payload, socket) do
    send(self(), :after_join_lobby)
    {:ok, assign(socket, :room_id, "lobby")}
  end
  def join("room:" <> room_id , _payload, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  def terminate(msg, socket) do
    payload = %{room_id: socket.topic, data: Presence.list(socket)}
    @endpoint.broadcast "room:lobby", "room_update:", payload
  end

  def handle_info(:after_join_lobby, socket) do
    socket
    |> track_prensence

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    socket
    |> track_prensence
    |> receive_current_counter

    {:noreply, socket}
  end

  defp track_prensence(socket) do
    # Publish current list of presences
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.name, %{
      online_at: inspect(System.system_time(:seconds))
    })

    socket
  end

  defp receive_current_counter(socket) do
    # Publish current timer-value
    timer = TimerRegistry.create_or_get(socket.assigns.room_id)
    counter = Timer.info(timer)
    push socket, "counter", %{value: counter}

    socket
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
    timer = TimerRegistry.create_or_get(socket.assigns.room_id)
    Timer.start(timer)
    {:noreply, socket}
  end

  def handle_in("stop", payload, socket) do
    # broadcast socket, "shout", payload
    timer = TimerRegistry.create_or_get(socket.assigns.room_id)
    Timer.stop(timer)
    {:noreply, socket}
  end

  def handle_in("reset", payload, socket) do
    # broadcast socket, "shout", payload
    timer = TimerRegistry.create_or_get(socket.assigns.room_id)
    Timer.reset(timer)
    {:noreply, socket}
  end
end
