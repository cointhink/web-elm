module Cointhink.Protocol exposing (..)

-- elm modules
import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (decodeString, field, array, map2, map3, map5, value, list)
import WebSocket

import Cointhink.Shared exposing (..)

type alias WsResponse = { id : String, class: String, object : Json.Decode.Value }
type alias WsRequest = { id : String, class: String, object: Json.Encode.Value }

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

