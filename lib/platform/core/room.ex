defmodule Platform.Core.Room do

  @derive {Phoenix.Param, key: :uuid}
  defstruct [
    :name,
    :uuid
  ]

end
