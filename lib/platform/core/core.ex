defmodule Platform.Core do
  @moduledoc """
  The Core context.
  """

  alias Platform.Repo
  alias Platform.Core.Room

  def list_rooms do
    []
  end

  def get_room!(id), do: %{}

end
