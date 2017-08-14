'use strict'
var ws_buffer = []
var _ws_connecting = false
var _ws_url, _ws_receive, _ws_socket

function ws_init (url, receive) {
  _ws_url = url
  _ws_receive = receive
  ws_connect()
}

function ws_connect () {
  _ws_socket = new WebSocket(_ws_url)
  _ws_connecting = true
  console.log('opening', _ws_url)
  _ws_socket.onopen = function (event) {
    _ws_connecting = false
    ws_drain()
  }
  _ws_socket.onmessage = (event) => {
    let o = JSON.parse(event.data)
    _ws_receive(o)
    ws_drain()
  }

  _ws_socket.onerror = (event) => {
    _ws_receive({id: "0", method: "WsOpenFail", object: {}})
  }

  return ws
}


function ws_drain() {
  if (ws_buffer.length > 0) {
    var orig_len = ws_buffer.length
    var msg = ws_buffer.shift()
    console.log('replaying buffer (len %d)', orig_len, msg);
    ws_send(ws, msg)
    if(msg.Method != "SessionCreate") {
      ws_drain()
    }
  }
}

function ws_send (ws, msgLower) {
  // protobuf json keyname hack
  var msg = {}
  Object.keys(msgLower).forEach(key => {
    var upperKey = key.charAt(0).toUpperCase() + key.slice(1)
    msg[upperKey] = msgLower[key]
  })
  msg.Object['@type'] = 'type.googleapis.com/proto.' + msg.Method
  console.log('ws_send', msg)
  if (_ws_socket.readyState == 1) {
    msg.Token = localStorage.getItem('token')
    let json = JSON.stringify(msg)
    _ws_socket.send(json)
  } else {
    console.log('buffering', msg)
    ws_buffer.push(msg)
    if (_ws_connecting == false) {
      ws_connect()
    }
  }
}
