port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing ( (:=), decodeString, decodeValue )

import Components
import Cointhink.Protocol exposing (..)
import Cointhink.Shared exposing (..)

port input : (Int -> msg) -> Sub msg
port graphdata : () -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = { ws_url: String, start_range : String }

wsSend : String -> Json.Encode.Value -> Cmd Msg
wsSend url say = WebSocket.send url (encode 2 (Debug.log "say" say))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    rpc = wsSend model.ws_url
  in
    case (Debug.log "Update Msg" msg) of
        Cointhink.Shared.Init ->
            ( Debug.log "model" model, Cmd.batch [ rpc exchangesRequest,
                                                   rpc (orderbookRequest "btc" "xusd") ] )
        Cointhink.Shared.OrderbookUpdate orderbook ->
            ( model, graphdata () )
        Cointhink.Shared.Noop ->
            ( model, Cmd.none )

jmsg : String -> Result String WsResponse
jmsg json =
    decodeString Cointhink.Protocol.job json

ws_parse : String -> Msg
ws_parse json =
  case jmsg json of
    Result.Ok value -> dispatch value
    Result.Err msg -> Cointhink.Shared.Noop

dispatch : WsResponse -> Msg
dispatch wsresponse =
  case (Debug.log "ws method" wsresponse.method) of
    "orderbook" ->
      let
        orderbookResult : Result String Orderbook
        orderbookResult = decodeValue orderbookDecoder wsresponse.object
      in
        case orderbookResult of
          Result.Ok value -> Cointhink.Shared.OrderbookUpdate value
          Result.Err msg -> Cointhink.Shared.Noop
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
