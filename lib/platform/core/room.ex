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

  ########################################################################
  ###
  ### Simple functional state transfer
  ###
  ########################################################################

  @doc """
  Should init a room with the default values

  iex> init_room()
  %{users: []}

  """
  def init_room do
    %{users: []}
  end

  @doc """
  List the current users in the room

  iex> list_users(%{users: []})
  []

  iex> list_users(%{users: [%{}]})
  [%{}]

  """
  def list_users(room) do
    Map.get(room, :users)
  end

  @doc """
  Add a user to the room

  iex> add_user(%{users: []}, %{})
  %{users: [%{}]}

  iex> add_user(%{users: [%{}]}, %{id: 1})
  %{users: [%{id: 1}, %{}]}
  """
  def add_user(room, user) do
    Map.put(room, :users, [user | room.users])
  end

  @doc """
  Remove a user from the room

  iex> remove_user(%{users: [%{id: 1}]}, 1)
  %{users: []}

  iex> remove_user(%{users: [%{id: 1}, %{id: 2}]}, 1)
  %{users: [%{id: 2}]}

  """
  def remove_user(room, id) do
    filtered_userlist = Enum.filter(room.users, fn(user) -> user.id != id end)
    Map.put(room, :users, filtered_userlist)
  end

end
