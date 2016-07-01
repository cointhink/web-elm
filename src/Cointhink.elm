port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing ( (:=), decodeString )

import Components
import Cointhink.Protocol exposing (..)
import Cointhink.Shared exposing (Msg)

port input : (Int -> msg) -> Sub msg
port graphdata : () -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = { ws_url: String, start_range : String }

wsSend : String -> Json.Encode.Value -> Cmd Msg
wsSend url say = WebSocket.send url (encode 2 (Debug.log "say" say))

exchangesRpc : Model -> Cmd Msg
exchangesRpc model = wsSend model.ws_url (exchangesRequest)

marketRpc : Model -> String -> String -> Cmd Msg
marketRpc model base quote = wsSend model.ws_url (coinrequest base quote)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "MESSAGE" msg) of
        Cointhink.Shared.Init ->
            ( Debug.log "model" model, Cmd.batch [ exchangesRpc model,
                                                   marketRpc model "btc" "xusd" ]
                                                    )
        Cointhink.Shared.Ask ->
            ( Debug.log "model" model, graphdata () )
        Cointhink.Shared.Noop ->
            ( model, Cmd.none )

jmsg : String -> Result String String
jmsg json =
    decodeString ("type" := Json.Decode.string) json

ws_parse : String -> Msg
ws_parse json =
  case (Debug.log "ws" (jmsg json)) of
    Result.Ok value -> dispatch value
    Result.Err msg -> Cointhink.Shared.Noop

dispatch : String -> Msg
dispatch method =
  case method of
    "bing" -> Cointhink.Shared.Ask
    _ -> Cointhink.Shared.Noop


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model ((Debug.log "flags" flags).url) "2014",
      Cmd.batch [ setup (), send Cointhink.Shared.Init ] )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)
