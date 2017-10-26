defmodule Platform.Core.RoomAgent do
  @moduledoc """
  The RoomAgent to hold state for a single room
  """
  use Agent

  @doc """
  Starts a new room.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{users: []} end)
  end

  @doc """
  Get a list of current users
  """
  def list_users(room) do
    Agent.get(room, &Map.get(&1, :users))
  end

  @doc """
  Add a user to the room
  """
  def add_user(room, user) do
    current_userlist = Agent.get(room, &Map.get(&1, :users))
    Agent.update(room, &Map.put(&1, :users, [%{} | current_userlist]))
  end

end
