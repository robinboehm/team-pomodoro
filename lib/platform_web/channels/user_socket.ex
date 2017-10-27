defmodule PlatformWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", PlatformWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"user" => user}, socket) do
    {:ok, assign(socket, :user, user)}
  end

  def id(_socket), do: nil
end
