module Cointhink.Protocol exposing (..)

import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (tuple2, object5, object2, value, (:=))

import Cointhink.Shared exposing (..)

type alias WsResponse = { rtype : String, object : Json.Decode.Value }

job : Json.Decode.Decoder WsResponse
job =
    object2 WsResponse
      ("type" := Json.Decode.string)
      ("object" := value)

orderbookRequest : String -> String -> Json.Encode.Value
orderbookRequest base quote = object [ ( "method" , string "orderbook" ),
                                       ( "params" , object [ ("base", string base),
                                                             ("quote", string quote),
                                                             ("days", int 1)
                                                           ] )
                                ]
orderbookDecoder : Json.Decode.Decoder Orderbook
orderbookDecoder =
  object5 Orderbook
          ("date" := Json.Decode.string)
          ("exchange" := Json.Decode.string)
          ("market" :=
             (object2
                 OrderbookMarket
                 ( "base" := Json.Decode.string )
                 ( "quote" := Json.Decode.string )
             )
          )
          ("bids" :=  Json.Decode.list (tuple2 (,) Json.Decode.string Json.Decode.float) )
          ("asks" :=  Json.Decode.list (tuple2 (,) Json.Decode.string Json.Decode.float) )

exchangesRequest : Json.Encode.Value
exchangesRequest = object [ ( "method" , string "exchanges" ) ]

