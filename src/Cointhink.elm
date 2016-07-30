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
port graphdataJs : Orderbook -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = {
    ws_url: String,
    base: String,
    quote: String,
    hours : Int,
    exchangesLive: List String,
    exchanges: List Exchange
  }

wsSend : String -> Json.Encode.Value -> Cmd Msg
wsSend url say = WebSocket.send url (encode 2 (Debug.log "say" say))

orderbookDo : (Json.Encode.Value -> Cmd Msg) -> Model -> String -> String -> (Model, Cmd Msg)
orderbookDo rpc model base quote =
  let
    updatedModel = { model | base = base, quote = quote }
  in
    ( Debug.log "updatedModel" updatedModel, rpc (orderbookRequest updatedModel.base updatedModel.quote) )


exchangeUpdate : Model -> Exchange -> ( Model, Cmd Msg )
exchangeUpdate model exchange =
  let
    updatedModel = { model | exchanges = (exchange :: model.exchanges) }
  in
    (updatedModel, Cmd.none)

addIfExchangeUnique : String -> List String -> List String
addIfExchangeUnique exchangeName exchangeNames =
  if List.member exchangeName exchangeNames then
    exchangeNames
  else
    ( exchangeName :: exchangeNames )

orderbookUpdate : Model -> Orderbook -> ( Model, Cmd Msg )
orderbookUpdate model orderbook =
  let
    updatedModel = { model | exchangesLive = (addIfExchangeUnique
                                                     orderbook.exchange
                                                     model.exchangesLive) }
  in
    (updatedModel, graphdataJs orderbook)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    rpc = wsSend model.ws_url
  in
    case msg of
      Cointhink.Shared.Init ->
        orderbookDo rpc model model.base model.quote
      Cointhink.Shared.ExchangesQuery ->
        ( model, rpc exchangesRequest )
      Cointhink.Shared.OrderbookUpdate orderbook ->
        orderbookUpdate model orderbook
      Cointhink.Shared.ExchangeUpdate exchange ->
        exchangeUpdate model exchange
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
    Result.Ok value -> dispatch value
    Result.Err msg -> Cointhink.Shared.Alert msg

dispatch : WsResponse -> Msg
dispatch wsresponse =
  case (Debug.log "ws response type" wsresponse.rtype) of
    "orderbook" ->
      let
        orderbookResult : Result String Orderbook
        orderbookResult = decodeValue orderbookDecoder wsresponse.object
      in
        case orderbookResult of
          Result.Ok value -> Cointhink.Shared.OrderbookUpdate value
          Result.Err msg -> Cointhink.Shared.Alert msg
    "exchange" ->
      let
        exchangeResult : Result String Exchange
        exchangeResult = decodeValue exchangeDecoder wsresponse.object
      in
        case exchangeResult of
          Result.Ok value -> Cointhink.Shared.ExchangeUpdate value
          Result.Err msg -> Cointhink.Shared.Alert msg
    _ -> Cointhink.Shared.Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String,
                     base : String,
                     quote : String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { ws_url = ((Debug.log "flags" flags).url),
        base = flags.base,
        quote = flags.quote,
        hours = 4,
        exchangesLive = [],
        exchanges = [] },
      Cmd.batch [ setup (), send Cointhink.Shared.Init,
                            send Cointhink.Shared.ExchangesQuery ] )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)
