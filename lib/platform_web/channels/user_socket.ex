defmodule PlatformWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", PlatformWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
