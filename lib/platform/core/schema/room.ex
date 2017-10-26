defmodule Platform.Core.Schema.Room do

  @derive {Phoenix.Param, key: :uuid}
  defstruct [
    :name,
    :uuid
  ]

end
