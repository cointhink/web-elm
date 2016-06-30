port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket

import Components

port output : () -> Cmd msg

view = Components.view

type alias Model = { url: String, start_range : String }

ws_url = "ws://echo.websocket.org"

moredata : String -> Cmd Msg
moredata say = WebSocket.send ws_url say

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "MESSAGE" msg) of
        Init ->
            ( Debug.log "model" model, moredata "init")
        Ask ->
            ( Debug.log "model" model, output () )
        Get x ->
            ( model, Cmd.none )

type Msg = Init | Ask | Get Int

port input : (Int -> msg) -> Sub msg

wsin str =
  case (Debug.log "ws" str) of
    "ab" -> Ask
    _ -> Ask

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen ws_url wsin

type alias Flags = { hostname : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model ("ws://" ++ (Debug.log "flags" flags).hostname) "2014",
      send Init )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)


