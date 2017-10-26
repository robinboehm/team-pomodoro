import $ from "jquery"
import socket from "./socket"

$("[data-room-uuid]").each((index, element) => {
  let roomUuid = $(element).data("room-uuid");
  console.log(roomUuid)

  let channel = socket.channel(`room:${roomUuid}`, {})
  channel.join()
    .receive("ok", resp => { console.log("Joined room successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
});

