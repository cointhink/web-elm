port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket

import Components

port output : () -> Cmd msg

view = Components.view

type alias Model = { ws_url: String, start_range : String }

moredata : String -> String -> Cmd Msg
moredata url say = WebSocket.send url say

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "MESSAGE" msg) of
        Init ->
            ( Debug.log "model" model, moredata model.ws_url "init")
        Ask ->
            ( Debug.log "model" model, output () )
        Get x ->
            ( model, Cmd.none )

type Msg = Init | Ask | Get Int

port input : (Int -> msg) -> Sub msg

ws_parse str =
  case (Debug.log "ws" str) of
    "ab" -> Ask
    _ -> Ask

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model ((Debug.log "flags" flags).url) "2014",
      send Init )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)


