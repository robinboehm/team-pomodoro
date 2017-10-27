defmodule Platform.Core do
  @moduledoc """
  The Core context.
  """

  alias Platform.Core.Room

  @rooms [
    %Room{name: "Sofaecke", uuid: "6A0466FA-38DD-45D9-B75B-8476D2F81F07", image: "kingston-chen-364070.jpg"},
    %Room{name: "Coffee-Lounge", uuid: "E9074C0A-FD2F-4778-A0D3-69E5A7201AD3", image: "michal-parzuchowski-324218.jpg"},
    %Room{name: "Zen", uuid: "AF4DC071-7920-409A-99C7-0DB0649EE0AA", image: "aperture-vintage-226404.jpg"}
  ]

  @doc """
  Get the list of rooms

  iex> list_rooms() |> Enum.map(&(&1.name))
  ["Sofaecke", "Coffee-Lounge", "Work"]

  iex> length(list_rooms())
  3
  """
  def list_rooms do
    @rooms
  end

  @doc """
  Get a specific room by id

  iex> get_room!("6A0466FA-38DD-45D9-B75B-8476D2F81F07")
  %Room{name: "Sofaecke", uuid: "6A0466FA-38DD-45D9-B75B-8476D2F81F07", image: "kingston-chen-364070.jpg" }

  iex> get_room!("not_existing")
  nil
  """
  def get_room!(id) do
    @rooms
    |> Enum.find(fn(room) -> room.uuid == id end)
  end
end
