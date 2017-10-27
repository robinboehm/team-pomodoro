defmodule Platform.Core.TimerRegistry do
  @moduledoc """
  A registry for room-agents
  """
  use GenServer

  alias Platform.Core.Timer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @doc """
  Looks up the room pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the room exists, `:error` otherwise.
  """
  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  @doc """
  Ensures there is a room associated with the given `name` in `server`.
  """
  def create_or_get(name) do
    GenServer.call(__MODULE__, {:create, name})
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
  Lookup for a Timer instance.
  If there is no instance -> :error (via Map.fetch)
  """
  def handle_call({:lookup, name}, _from, {names, _} = state) do
    # Sascha: handle_call is synchron and return {:reply, result, state}
    {:reply, Map.fetch(names, name), state}
  end

  @doc """
  Create or get a new Timer instance
  """
  def handle_call({:create, name}, _from, {names, refs} = state) do
    if Map.has_key?(names, name) do
      {:reply, Map.get(names, name), state}
    else
      {:ok, pid} = Timer.start_link(room_id: name)
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:reply, pid, {names, refs}}
    end
  end

  @doc """
  Handle crash of an Timer -> Delete from list.

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
