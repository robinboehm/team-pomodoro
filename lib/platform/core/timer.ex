defmodule Platform.Core.Timer do
  @moduledoc """
  A registry for room-agents
  """
  use GenServer

  @default_time 25*60 # 25minutes pomodoro

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link([room_id: name] = opts) do
    GenServer.start_link(__MODULE__, name, opts)
  end

  @doc """

  """
  def start(timer) do
    GenServer.cast(timer, {:start})
  end

  @doc """

  """
  def stop(timer) do
    GenServer.cast(timer, {:stop})
  end

  @doc """

  """
  def reset(timer) do
    GenServer.cast(timer, {:reset})
  end

  ## Server Callbacks

  @doc """
  Initialize the registry with an empty list.

  The AgentRooms will be stored here in following format:

  name : <PID>

  """
  def init(name) do
    running = false
    counter = @default_time
    {:ok, {running, counter, name}}
  end

  @doc """
  """
  def handle_cast({:start}, {false = _running, counter, name}) do
    # Start the timer
    Process.send_after(self(), :tick, 1_000)

    running = true
    {:noreply, {running, (counter-1), name}}
  end
  def handle_cast({:start}, {running, counter, name}) do
    {:noreply, {running, counter, name}}
  end

  def handle_cast({:stop}, {_running, counter, name}) do
    running = false
    {:noreply, {running, counter, name}}
  end

  def handle_cast({:reset}, {_running, _counter, name}) do
    running = false
    counter = @default_time
    PlatformWeb.Endpoint.broadcast("room:#{name}", "counter", %{value: counter})
    {:noreply, {running, counter, name}}
  end

  def handle_info(:tick, {true = _running, 0 = counter, name}) do
    running = false
    {:noreply, {running, counter, name}}
  end
  def handle_info(:tick, {true = running, counter, name}) do
    Process.send_after(self(), :tick, 1_000)
    PlatformWeb.Endpoint.broadcast("room:#{name}", "counter", %{value: counter})
    {:noreply, {running, (counter-1), name}}
  end
  def handle_info(:tick, {false = running, counter, name}) do
    {:noreply, {running, counter, name}}
  end
end
