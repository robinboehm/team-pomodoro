defmodule Platform.Core.RoomRegistry do
  @moduledoc """
  A registry for room-agents
  """
  use GenServer

  alias Platform.Core.RoomAgent

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the room pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the room exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a room associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  ## Server Callbacks

  @doc """
  Initialize the registry with an empty list.

  The AgentRooms will be stored here in following format:

  room.uuid : <PID>

  """
  def init(:ok) do
    {:ok, %{}}
  end

  @doc """
  Lookup for a RoomAgent instance.
  If there is no instance -> :error (via Map.fetch)
  """
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  @doc """
  Create or get a new RoomAgent instance
  """
  def handle_call({:create, name}, _from, names) do
    if Map.has_key?(names, name) do
      {:reply, Map.get(names, name), names}
    else
      {:ok, room} = RoomAgent.start_link([])
      {:reply, room, Map.put(names, name, room)}
    end
  end
end
