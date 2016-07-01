module Cointhink.Protocol exposing (..)

import Json.Encode exposing (object, encode, string, int)
import Json.Decode exposing (object2, value, (:=))

type alias WsResponse = { method : String, object : Json.Decode.Value }

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

exchangesRequest : Json.Encode.Value
exchangesRequest = object [ ( "method" , string "exchanges" ) ]

