module Schedules.AlgorithmSchema exposing (..)

import Json.Encode
import Json.Decode exposing (field)


type alias Schema =
    { exchange : SchemaExchange
    , market : SchemaMarket
    , percentChg : SchemaPercent_chg
    }


type alias SchemaExchange =
    { type_ : String
    , default : String
    }


type alias SchemaMarket =
    { type_ : String
    , default : String
    }


type alias SchemaPercent_chg =
    { type_ : String
    , default : Int
    }


decodeSchema : Json.Decode.Decoder Schema
decodeSchema =
    Json.Decode.map3 Schema
        (field "exchange" decodeSchemaExchange)
        (field "market" decodeSchemaMarket)
        (field "percentChg" decodeSchemaPercent_chg)


decodeSchemaExchange : Json.Decode.Decoder SchemaExchange
decodeSchemaExchange =
    Json.Decode.map2 SchemaExchange
        (field "type" Json.Decode.string)
        (field "default" Json.Decode.string)


decodeSchemaMarket : Json.Decode.Decoder SchemaMarket
decodeSchemaMarket =
    Json.Decode.map2 SchemaMarket
        (field "type" Json.Decode.string)
        (field "default" Json.Decode.string)


decodeSchemaPercent_chg : Json.Decode.Decoder SchemaPercent_chg
decodeSchemaPercent_chg =
    Json.Decode.map2 SchemaPercent_chg
        (field "type" Json.Decode.string)
        (field "default" Json.Decode.int)


encodeSchema : Schema -> Json.Encode.Value
encodeSchema record =
    Json.Encode.object
        [ ( "exchange", encodeSchemaExchange <| record.exchange )
        , ( "market", encodeSchemaMarket <| record.market )
        , ( "percentChg", encodeSchemaPercent_chg <| record.percentChg )
        ]


encodeSchemaExchange : SchemaExchange -> Json.Encode.Value
encodeSchemaExchange record =
    Json.Encode.object
        [ ( "type", Json.Encode.string <| record.type_ )
        , ( "default", Json.Encode.string <| record.default )
        ]


encodeSchemaMarket : SchemaMarket -> Json.Encode.Value
encodeSchemaMarket record =
    Json.Encode.object
        [ ( "type", Json.Encode.string <| record.type_ )
        , ( "default", Json.Encode.string <| record.default )
        ]


encodeSchemaPercent_chg : SchemaPercent_chg -> Json.Encode.Value
encodeSchemaPercent_chg record =
    Json.Encode.object
        [ ( "type", Json.Encode.string <| record.type_ )
        , ( "default", Json.Encode.int <| record.default )
        ]
