defmodule Platform.Core.RoomTimer do
  @moduledoc """
  A registry for room-agents
  """
  use GenServer

  @default_time 25*60 # 25minutes pomodoro

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
    GenServer.cast(__MODULE__, {:start})
  end

  @doc """

  """
  def stop() do
    GenServer.cast(__MODULE__, {:stop})
  end

  @doc """

  """
  def reset() do
    GenServer.cast(__MODULE__, {:reset})
  end

  ## Server Callbacks

  @doc """
  Initialize the registry with an empty list.

  The AgentRooms will be stored here in following format:

  room.uuid : <PID>

  """
  def init(:ok) do
    running = false
    counter = @default_time
    {:ok, {running, counter}}
  end

  @doc """
  """
  def handle_cast({:start}, {_, counter}) do
    # Start the timer
    Process.send_after(self(), :tick, 1_000)

    running = true
    {:noreply, {running, counter}}
  end

  def handle_cast({:stop}, {_running, counter}) do
    running = false
    {:noreply, {running, counter}}
  end

  def handle_cast({:reset}, {_running, _counter}) do
    running = false
    {:noreply, {running, @default_time}}
  end

  def handle_info(:tick, {true = _running, 0 = counter}) do
    running = false
    {:noreply, {running, counter}}
  end
  def handle_info(:tick, {true = running, counter}) do
    Process.send_after(self(), :tick, 1_000)
    PlatformWeb.Endpoint.broadcast("room:6A0466FA-38DD-45D9-B75B-8476D2F81F07", "counter", %{value: counter})
    {:noreply, {running, (counter-1)}}
  end
  def handle_info(:tick, {false = running, counter}) do
    {:noreply, {running, counter}}
  end
end
