defmodule Platform.Presence do
  @moduledoc """
  The presence module
  """

  use Phoenix.Presence, otp_app: :platform,
                        pubsub_server: Platform.PubSub
end
