function ws_init(url, receive) {
  let ws = new WebSocket(url)
  ws.onopen = function (event) {
    console.log('onopen', event)
  }
  ws.onmessage = (event) => {
    let o = JSON.parse(event.data)
    receive(o)
  }
  return ws
}

function ws_send(ws, msg) {
  ws.send(JSON.stringify(msg))
}
