module Proto.Market_prices exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/market_prices.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Proto.Market_price exposing (..)


type alias MarketPrices =
    { prices : List MarketPrice -- 1
    }


marketPricesDecoder : JD.Decoder MarketPrices
marketPricesDecoder =
    JD.lazy <| \_ -> decode MarketPrices
        |> repeated "Prices" marketPriceDecoder


marketPricesEncoder : MarketPrices -> JE.Value
marketPricesEncoder v =
    JE.object <| List.filterMap identity <|
        [ (repeatedFieldEncoder "Prices" marketPriceEncoder v.prices)
        ]
