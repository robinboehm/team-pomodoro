defmodule Platform.Core.RoomTimer do
  @moduledoc """
  A registry for room-agents
  """
  use GenServer

  @default_time 25 * 60 # 25 minutes pomodoro
  @endpoint PlatformWeb.Endpoint # move this to a config option

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @doc """
  Starts the timer
  """
  def start do
    GenServer.cast(__MODULE__, {:start})
  end

  @doc """
  Stops the timer
  """
  def stop do
    GenServer.cast(__MODULE__, {:stop})
  end

  @doc """
  Resets the timer
  """
  def reset do
    GenServer.cast(__MODULE__, {:reset})
  end

  ## Server Callbacks

  @doc """
  Initialize the registry with an empty list.

  The AgentRooms will be stored here in following format:

  room.uuid : <PID>
  """
  def init(:ok) do
    counter = @default_time
    {:ok, {:paused, counter}}
  end

  @doc """
  """
  def handle_cast({:start}, {:paused, counter}) do
    # Start the timer
    Process.send_after(self(), :tick, 1_000)

    {:noreply, {:running, counter}}
  end
  def handle_cast({:start}, {:running, counter}) do
    {:noreply, {:running, counter}}
  end

  def handle_cast({:stop}, {_state, counter}) do
    {:noreply, {:paused, counter}}
  end

  def handle_cast({:reset}, {_state, _counter}) do
    counter = @default_time
    @endpoint.broadcast("room:6A0466FA-38DD-45D9-B75B-8476D2F81F07", "counter", %{value: counter})
    {:noreply, {:paused, counter}}
  end

  def handle_info(:tick, {:running, 0 = counter}) do
    {:noreply, {:paused, counter}}
  end
  def handle_info(:tick, {:running, counter}) do
    Process.send_after(self(), :tick, 1_000)
    @endpoint.broadcast("room:6A0466FA-38DD-45D9-B75B-8476D2F81F07", "counter", %{value: counter})
    {:noreply, {:running, counter - 1}}
  end
  def handle_info(:tick, {:paused, counter}) do
    {:noreply, {:paused, counter}}
  end
end
