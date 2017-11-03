defmodule Platform.Core.Timer do
  @moduledoc """
  A registry for timer-agents
  """
  use GenServer

  @default_time 25 * 60 # 25 minutes pomodoro
  @endpoint PlatformWeb.Endpoint # move this to a config option

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link([timer_id: name] = opts) do
    GenServer.start_link(__MODULE__, name, opts)
  end

  @doc """

  """
  def start(timer) do
    GenServer.cast(timer, :start)
  end

  @doc """

  """
  def stop(timer) do
    GenServer.cast(timer, :stop)
  end

  @doc """

  """
  def reset(timer) do
    GenServer.cast(timer, :reset)
  end

  @doc """

  """
  def info(timer) do
    GenServer.call(timer, :info)
  end

  ## Server Callbacks

  @doc """
  Initialize the registry with an empty list.

  The Agenttimers will be stored here in following format:

  name : <PID>

  """
  def init(name) do
    counter = @default_time
    {:ok, {:paused, counter, name}}
  end

  @doc """
  """
  def handle_cast(:start, {:paused, counter, name}) do
    # Start the timer
    Process.send_after(self(), :tick, 1_000)

    {:noreply, {:running, (counter - 1), name}}
  end
  def handle_cast(:start, {:running, counter, name}) do
    {:noreply, {:running, counter, name}}
  end

  def handle_cast(:stop, {:running, counter, name}) do
    {:noreply, {:paused, counter, name}}
  end

  def handle_cast(:reset, {_running, _counter, name}) do
    counter = @default_time
    @endpoint.broadcast("room:#{name}", "counter", %{value: counter})
    {:noreply, {:paused, counter, name}}
  end

  def handle_info(:tick, {:running, 0 = counter, name}) do
    {:noreply, {:paused, counter, name}}
  end
  def handle_info(:tick, {:running, counter, name}) do
    Process.send_after(self(), :tick, 1_000)
    @endpoint.broadcast("room:#{name}", "counter", %{value: counter})
    {:noreply, {:running, (counter - 1), name}}
  end
  def handle_info(:tick, {:paused, counter, name}) do
    {:noreply, {:paused, counter, name}}
  end

  def handle_call(:info, _from, {running, counter, name}) do
    {:reply, counter, {running, counter, name}}
  end
end
