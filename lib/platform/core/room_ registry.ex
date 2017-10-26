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
    # name -> pid
    names = %{}
    # ref -> name
    refs  = %{}
    {:ok, {names, refs}}
  end

  @doc """
  Lookup for a RoomAgent instance.
  If there is no instance -> :error (via Map.fetch)
  """
  def handle_call({:lookup, name}, _from, {names, _} = state) do
    # Sascha: handle_call is synchron and return {:reply, result, state}
    {:reply, Map.fetch(names, name), state}
  end

  @doc """
  Create or get a new RoomAgent instance
  """
  def handle_call({:create, name}, _from, {names, refs} = state) do
    if Map.has_key?(names, name) do
      {:reply, Map.get(names, name), state}
    else
      {:ok, pid} = RoomAgent.start_link([])
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:reply, pid, {names, refs}}
    end
  end

  @doc """
  Handle crash of an RoomAgent -> Delete from list.

  The Down-Event is triggered via Process.monitor(pid)
  """
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    # handle_info is async and don't expect a return,
    # so only modify our state
    {:noreply, {names, refs}}
  end

  @doc """
  Discards any unknown message
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
