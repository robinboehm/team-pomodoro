defmodule Platform.Core.RoomTimer do
  @moduledoc """
  A registry for room-agents
  """
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @doc """

  """
  def start() do
    GenServer.call(__MODULE__, {:start})
  end

  ## Server Callbacks

  @doc """
  Initialize the registry with an empty list.

  The AgentRooms will be stored here in following format:

  room.uuid : <PID>

  """
  def init(:ok) do
    running = false
    counter  = 25*60 # 25minutes pomodoro
    IO.inspect Process.send_after(self(), :tick, 1_000)
    {:ok, {running, counter}}
  end

  @doc """
  """
  def handle_cast({:start}, _from, {_, counter}) do
    # Start the timer
    Process.send_after(self(), :tick, 1_000)

    running = true
    {:noreply, {running, counter}}
  end

  def handle_cast({:stop}, _from, {_, counter}) do
    running = false
    {:noreply, {running, counter}}
  end

  def handle_info(:tick, {true = running, counter}) do
    Process.send_after(self(), :tick, 1_000)
    IO.inspect counter
    {:noreply, {running, (counter-1)}}
  end
  def handle_info(:tick, {false = running, counter}) do
    {:noreply, {running, (counter)}}
  end
end
