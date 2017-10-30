import $ from "jquery"
import socket from "./socket"
import {Presence} from "phoenix"


$("[data-room-uuid]").each((index, element) => {
  let roomUuid = $(element).data("room-uuid");
  let channel = joinChannel(roomUuid);
  trackPresence(channel);
  createCounterEvents(channel);
});


function trackPresence(channel) {
  let presences = {} // client's initial empty presence state

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
      presences = Presence.syncState(presences, state)
      $("#presence_users").text(Object.keys(presences).join(", "))
    })
    // receive "presence_diff" from server, containing join/leave events
    channel.on("presence_diff", diff => {
      presences = Presence.syncDiff(presences, diff)
      $("#presence_users").text(Object.keys(presences).join(", "))
    })

  // receive "presence_diff" from server, containing join/leave events
    channel.on("room_update", state => {
      presences = Presence.syncState(presences, state.data, onJoin, onLeave)
      let elem = $(`[data-show-users-in-room="${state.room_id}"]`).first().text(Object.keys(presences).join(", "));
    //   presences = Presence.syncState(presences, state.data)
    //  console.log("[data-show-users-in-room=\""+state.room_id+"\"]")
    //

  })


}


function joinChannel(roomUuid) {
  let channel = socket.channel(`room:${roomUuid}`, {})
  channel.join()
    .receive("ok", resp => { console.log("Joined room successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
  return channel;
}

function createCounterEvents(channel) {
  channel.on("counter", ({value: value}) => {
    $("#counter").text(convertSecondsToPrettyTime(value));
  })

  $("#start-counter").on("click", (event) => {
    channel.push("start");
  });

  $("#stop-counter").on("click", (event) => {
    channel.push("stop");
  });

  $("#reset-counter").on("click", (event) => {
    channel.push("reset");
  });
}

function convertSecondsToPrettyTime(time) {
  function str_pad_left(string) {
    let pad = '0';
    let length = 2;
    return (new Array(length+1).join(pad)+string).slice(-length);
  }

  let minutes = str_pad_left(Math.floor(time / 60))
  let seconds = str_pad_left(time - minutes * 60)

  return `${minutes}:${seconds}`
}




