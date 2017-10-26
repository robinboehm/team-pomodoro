defmodule Platform.Core.Schema.Room do
  @moduledoc """
  The Room Schema.
  """

  @derive {Phoenix.Param, key: :uuid}
  defstruct [
    :name,
    :uuid
  ]

end
