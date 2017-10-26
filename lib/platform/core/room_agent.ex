defmodule Platform.Core.RoomAgent do
  @moduledoc """
  The RoomAgent to hold state for a single room
  """
  use Agent

  alias Platform.Core.Room

  @doc """
  Starts a new room.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> Room.init_room() end)
  end

  @doc """
  Get a list of current users
  """
  def list_users(room) do
    Agent.get(room, &Room.list_users(&1))
  end

  @doc """
  Add a user to the room
  """
  def add_user(room, user) do
    Agent.update(room, &Room.add_user(&1, user))
  end

  @doc """
  Add a user to the room
  """
  def remove_user(room, id) do
    Agent.update(room, &Room.remove_user(&1, id))
  end

end
