port module Cointhink exposing (init, subscriptions, view, update)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing ( (:=), decodeString, decodeValue )
import String

import Components
import Cointhink.Protocol exposing (..)
import Cointhink.Shared exposing (..)

port input : (Int -> msg) -> Sub msg
port graphdataJs : Orderbook -> Cmd msg
port setup : () -> Cmd msg

view = Components.view

type alias Model = {
    ws_url: String,
    market: Market,
    hours : Int,
    exchanges: List Exchange,
    markets: List Market
  }

wsSend : String -> Json.Encode.Value -> Cmd Msg
wsSend url say = WebSocket.send url (encode 2 (Debug.log "say" say))

orderbookDo : (Json.Encode.Value -> Cmd Msg) -> Model -> (Model, Cmd Msg)
orderbookDo rpc model =
  ( Debug.log "updatedModel" model, rpc (orderbookRequest model.market.base model.market.quote) )


exchangeUpdate : Model -> Exchange -> ( Model, Cmd Msg )
exchangeUpdate model exchange =
  let
    updatedModel = { model | exchanges = addExchangeIfMissing exchange model.exchanges,
                             markets = addMarketsIfMissing exchange.markets model.markets }
  in
    (updatedModel, Cmd.none)

addExchangeIfMissing : Exchange -> List Exchange -> List Exchange
addExchangeIfMissing exchange exchanges =
  if List.member exchange.id (List.map (\e -> e.id) exchanges) then
    exchanges
  else
    ( exchange :: exchanges )

addMarketsIfMissing : List Market -> List Market -> List Market
addMarketsIfMissing newMarkets markets =
 (newMarkets ++ markets)

orderbookUpdate : Model -> Orderbook -> ( Model, Cmd Msg )
orderbookUpdate model orderbook =
  let
    updatedModel = model
  in
    (updatedModel, graphdataJs orderbook)

marketSet : Model -> String -> ( Model, Cmd Msg)
marketSet model marketName =
  (model, Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    rpc = wsSend model.ws_url
  in
    case msg of
      Cointhink.Shared.OrderbookQuery ->
        orderbookDo rpc model
      Cointhink.Shared.ExchangesQuery ->
        ( model, rpc exchangesRequest )
      Cointhink.Shared.OrderbookUpdate orderbook ->
        orderbookUpdate model orderbook
      Cointhink.Shared.ExchangeUpdate exchange ->
        exchangeUpdate model exchange
      Cointhink.Shared.Alert string ->
        ( model, Cmd.none )
      Cointhink.Shared.MarketChoice marketName ->
        let
          parts = String.split "/" marketName
          baseMaybe = List.head parts
          quoteMaybe = List.head (Maybe.withDefault [] (List.tail parts))
          newMarket = { base = Maybe.withDefault "BTC" baseMaybe,
                        quote = Maybe.withDefault "USD" quoteMaybe }
        in
          ( { model | market = newMarket }, Cmd.none )
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
  case wsresponse.rtype of
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
        market = { base = flags.base, quote = flags.quote },
        hours = 4,
        exchanges = [],
        markets = [] },
      Cmd.batch [ setup (), send Cointhink.Shared.OrderbookQuery,
                            send Cointhink.Shared.ExchangesQuery ] )

send : Msg -> Cmd Msg
send msg =
  Task.perform identity identity (Task.succeed msg)
