module Cointhink.Protocol exposing (
                                      coinrequest,
                                      exchangesRequest
                                     )

import Json.Encode exposing (object, encode, string, int)

import Cointhink.Shared

coinrequest : String -> String -> Json.Encode.Value
coinrequest base quote = object [ ( "method" , string "orderbook" ),
                                  ( "params" , object [ ("base", string base),
                                                        ("quote", string quote),
                                                        ("days", int 1)
                                                      ] )
                                ]
exchangesRequest = object [ ( "method" , string "exchanges" ) ]
