port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket
import Json.Encode exposing (object, encode, string)

import Components

type Msg = Init | Ask | Noop

port input : (Int -> msg) -> Sub msg
port graphdata : () -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = { ws_url: String, start_range : String }

moredata : String -> Json.Encode.Value -> Cmd Msg
moredata url say = WebSocket.send url (Debug.log "say" (encode 2 say))

marketquery : Model -> String -> String -> Cmd Msg
marketquery model base quote = moredata model.ws_url (coinrequest base quote)

coinrequest : String -> String -> Json.Encode.Value
coinrequest base quote = object [ ("base", string base), ("quote", string quote) ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "MESSAGE" msg) of
        Init ->
            ( Debug.log "model" model, marketquery model "btc" "usd"
                                                    )
        Ask ->
            ( Debug.log "model" model, graphdata () )
        Noop ->
            ( model, Cmd.none )


ws_parse : String -> Msg
ws_parse str =
  case (Debug.log "ws" str) of
    "ab" -> Ask
    _ -> Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model ((Debug.log "flags" flags).url) "2014",
      Cmd.batch [ setup (), send Init ] )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)
