defmodule Platform.Core.Room do
  @moduledoc """
  The Room Schema.
  """

  @derive {Phoenix.Param, key: :uuid}
  defstruct [
    :name,
    :uuid,
    :image
  ]

end
