module Cointhink.Protocol exposing (..)

-- elm modules
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (decodeString, field, array, map2, map3, map5, value, list)
import WebSocket

import Cointhink.Shared exposing (..)

type alias WsResponse = { rtype : String, object : Json.Decode.Value }

ws_subscription : (WsResponse -> msg) -> String -> Sub msg
ws_subscription dispatch ws_url =
  WebSocket.listen ws_url (ws_parse dispatch)

wsSend : String -> Json.Encode.Value -> Cmd msg
wsSend url say = WebSocket.send
                      (Debug.log "ws url" url)
                      (Debug.log "Protocol.wsSend" (encode 2 say))

ws_parse : (WsResponse -> msg) -> String -> msg
ws_parse dispatch json =
  case jmsg json of
    Result.Ok value -> dispatch value
    Result.Err msg -> dispatch (WsResponse "err" (string "z"))

jmsg : String -> Result String WsResponse
jmsg json =
    decodeString job json

job : Json.Decode.Decoder WsResponse
job =
    map2 WsResponse
      (field "type" Json.Decode.string)
      (field "object" value)

orderbookRequest : String -> String -> Json.Encode.Value
orderbookRequest base quote =
  object [ ( "method" , string "orderbook" ),
           ( "params" , object [
                         ("base", string base),
                         ("quote", string quote),
                         ("hours", int 4)
                               ]
           )
         ]

marketDecoder =
      map2 Market
                 (field "base" Json.Decode.string )
                 (field "quote" Json.Decode.string )

offerDecoder =
      map2 Offer
                 (field "price" Json.Decode.string )
                 (field "quantity" Json.Decode.float )

orderbookDecoder : Json.Decode.Decoder Orderbook
orderbookDecoder =
  map5 Orderbook
          (field "date" Json.Decode.string)
          (field "exchange" Json.Decode.string)
          (field "market" marketDecoder)
          (field "bids"  (list offerDecoder) )
          (field "asks"  (list offerDecoder) )

exchangesRequest : Json.Encode.Value
exchangesRequest = object [ ( "method" , string "exchanges" ) ]

exchangeDecoder : Json.Decode.Decoder Exchange
exchangeDecoder =
  map3 Exchange
    (field "id" Json.Decode.string)
    (field "markets" (Json.Decode.list marketDecoder) )
    (field "date" Json.Decode.string)

