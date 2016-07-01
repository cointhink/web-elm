module Cointhink.Protocol exposing (
                                      coinRequest,
                                      exchangesRequest
                                     )

import Json.Encode exposing (object, encode, string, int)

coinRequest : String -> String -> Json.Encode.Value
coinRequest base quote = object [ ( "method" , string "orderbook" ),
                                  ( "params" , object [ ("base", string base),
                                                        ("quote", string quote),
                                                        ("days", int 1)
                                                      ] )
                                ]

exchangesRequest : Json.Encode.Value
exchangesRequest = object [ ( "method" , string "exchanges" ) ]
