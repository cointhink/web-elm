var ws_buffer = []
function ws_init(url, receive) {
  let ws = new WebSocket(url)
  console.log('opening', url)
  ws.onopen = function (event) {
    //console.log('onopen', event)
    ws_buffer.forEach(msg => {console.log('replaying buffer', msg); ws_send(ws, msg)})
  }
  ws.onmessage = (event) => {
    let o = JSON.parse(event.data)
    receive(o)
  }
  return ws
}

function ws_send(ws, msg) {
  if (ws.readyState == 1) {
    ws.send(JSON.stringify(msg))
  } else {
    console.log('buffering', msg)
    ws_buffer.push(msg)
  }
}
