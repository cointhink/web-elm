port module Cointhink.Markets exposing (app)

import Platform.Cmd exposing (Cmd)
import Task
import WebSocket
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (decodeString, decodeValue)
import String
import Navigation

import Cointhink.Components
import Cointhink.Protocol exposing (..)
import Cointhink.Shared exposing (..)

port graphdataJs : Orderbook -> Cmd msg
port setup : () -> Cmd msg

view = Cointhink.Components.view

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
  let
    missingMarkets = List.filter (\market -> not(List.member market markets)) newMarkets
  in
   List.sortBy .base (missingMarkets ++ markets)

orderbookUpdate : Model -> Orderbook -> ( Model, Cmd Msg )
orderbookUpdate model orderbook =
  let
    updatedModel = model
  in
    (updatedModel, graphdataJs orderbook)

marketNameToMarket :  String -> Market
marketNameToMarket name =
  let
    parts = String.split "/" name
    baseMaybe = List.head parts
    quoteMaybe = List.head (Maybe.withDefault [] (List.tail parts))
    base = Maybe.withDefault "BTC" baseMaybe
    quote = Maybe.withDefault "USD" quoteMaybe
  in
    { base = base, quote = quote }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    rpc = wsSend model.ws_url
  in
    case msg of
      OrderbookQuery ->
        orderbookDo rpc model
      ExchangesQuery ->
        ( model, rpc exchangesRequest )
      OrderbookUpdate orderbook ->
        orderbookUpdate model orderbook
      ExchangeUpdate exchange ->
        exchangeUpdate model exchange
      Alert string ->
        ( model, Cmd.none )
      MarketChoice marketName ->
        ( { model | market = marketNameToMarket marketName },
          Cmd.batch [ setup(),
                      send OrderbookQuery ] )
      Noop ->
        ( model, Cmd.none )

jmsg : String -> Result String WsResponse
jmsg json =
    decodeString Cointhink.Protocol.job json

ws_parse : String -> Msg
ws_parse json =
  case jmsg json of
    Result.Ok value -> dispatch value
    Result.Err msg -> Alert msg

dispatch : WsResponse -> Msg
dispatch wsresponse =
  case wsresponse.rtype of
    "orderbook" ->
      let
        orderbookResult : Result String Orderbook
        orderbookResult = decodeValue orderbookDecoder wsresponse.object
      in
        case orderbookResult of
          Result.Ok value -> OrderbookUpdate value
          Result.Err msg -> Alert msg
    "exchange" ->
      let
        exchangeResult : Result String Exchange
        exchangeResult = decodeValue exchangeDecoder wsresponse.object
      in
        case exchangeResult of
          Result.Ok value -> ExchangeUpdate value
          Result.Err msg -> Alert msg
    _ -> Noop

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen model.ws_url ws_parse

type alias Flags = { url : String,
                     base : String,
                     quote : String }

init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
  let
    debug_url = (Debug.log "init location" location.href)
    debug_flags = (Debug.log "init flags" flags)
  in
    ( { ws_url = flags.url,
        market = { base = flags.base, quote = flags.quote },
        hours = 4,
        exchanges = [],
        markets = [] },
      Cmd.none )

fromUrl : Navigation.Location -> Msg
fromUrl url =
  let
    debug_url = (Debug.log "fromUrl" url)
  in
    Noop

send : Msg -> Cmd Msg
send msg =
  Task.perform identity (Task.succeed msg)

urlUpdate : Result String Int -> Model -> (Model, Cmd msg)
urlUpdate urlParserResult model =
  case urlParserResult of
    Ok newCount ->
      ({model | hours = (Debug.log "newCount" newCount) }, Cmd.none)

    Err _ ->
      (model, Navigation.modifyUrl (toUrl 0))

toUrl : Int -> String
toUrl count =
  "#/" ++ toString count

app = Navigation.programWithFlags
        fromUrl
        {
          init = init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }