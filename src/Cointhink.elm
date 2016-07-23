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
port graphdata : Orderbook -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = {
                     ws_url: String,
                     base: String,
                     quote: String,
                     hours : Int
                   }

wsSend : String -> Json.Encode.Value -> Cmd Msg
wsSend url say = WebSocket.send url (encode 2 (Debug.log "say" say))

quotePair model base quote = Model model.ws_url base quote model.hours

quoteDo rpc model base quote =
  let
    updatedModel = quotePair model base quote
  in
    ( Debug.log "updatedModel" updatedModel, rpc (orderbookRequest updatedModel.base updatedModel.quote) )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    rpc = wsSend model.ws_url
  in
    case msg of
        Cointhink.Shared.Init ->
            quoteDo rpc model "USDT" "BTC"
        Cointhink.Shared.OrderbookUpdate orderbook ->
            ( model, graphdata (Debug.log "orderbook" orderbook) )
        Cointhink.Shared.Alert string ->
            ( model, Cmd.none )
        Cointhink.Shared.Noop ->
            ( model, Cmd.none )

jmsg : String -> Result String WsResponse
jmsg json =
    decodeString Cointhink.Protocol.job json

ws_parse : String -> Msg
ws_parse json =
  case jmsg json of
    Result.Ok value -> dispatch (Debug.log "value" value)
    Result.Err msg -> Cointhink.Shared.Alert msg

dispatch : WsResponse -> Msg
dispatch wsresponse =
  case (Debug.log "ws response type" wsresponse.rtype) of
    "orderbook" ->
      let
        orderbookResult : Result String Orderbook
        orderbookResult = decodeValue orderbookDecoder wsresponse.object
      in
        case (Debug.log "obr" orderbookResult) of
          Result.Ok value -> Cointhink.Shared.OrderbookUpdate value
          Result.Err msg -> Cointhink.Shared.Alert msg
    _ -> Cointhink.Shared.Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model ((Debug.log "flags" flags).url) "USDT" "BTC" 4,
      Cmd.batch [ setup (), send Cointhink.Shared.Init ] )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)
