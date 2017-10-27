defmodule PlatformWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", PlatformWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"name" => name}, socket) do
    {:ok, assign(socket, :name, name)}
  end

  def id(_socket), do: nil
end
