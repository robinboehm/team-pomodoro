defmodule Platform.Presence do
  use Phoenix.Presence, otp_app: :platform,
                        pubsub_server: Platform.PubSub
end
