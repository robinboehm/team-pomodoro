import $ from "jquery"
import socket from "./socket"
import {Presence} from "phoenix"

$("[data-room-uuid]").each((index, element) => {
  let roomUuid = $(element).data("room-uuid");
  console.log(roomUuid)

  let presences = {} // client's initial empty presence state

  let channel = socket.channel(`room:${roomUuid}`, {})
  channel.join()
    .receive("ok", resp => { console.log("Joined room successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

    let onJoin = (id, current, newPres) => {
      if(!current){
        console.log("user has entered for the first time", newPres)
      } else {
        console.log("user additional presence", newPres)
      }
    }
    // detect if user has left from all tabs/devices, or is still present
    let onLeave = (id, current, leftPres) => {
      if(current.metas.length === 0){
        console.log("user has left from all devices", leftPres)
      } else {
        console.log("user left from a device", leftPres)
      }
    }

    // receive initial presence data from server, sent after join
    channel.on("presence_state", state => {
      presences = Presence.syncState(presences, state, onJoin, onLeave)
      console.log(Presence.list(presences))
    })
    // receive "presence_diff" from server, containing join/leave events
    channel.on("presence_diff", diff => {
      presences = Presence.syncDiff(presences, diff, onJoin, onLeave)
      console.log(presences)
    })

    channel.on("counter", ({value: value}) => {
      console.log(value)
      $("#counter").text(value);
    })
});

