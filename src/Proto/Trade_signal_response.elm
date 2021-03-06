module Proto.Trade_signal_response exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/trade_signal_response.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias TradeSignalResponse =
    { ok : Bool -- 1
    , message : String -- 2
    , orderId : String -- 3
    }


tradeSignalResponseDecoder : JD.Decoder TradeSignalResponse
tradeSignalResponseDecoder =
    JD.lazy <| \_ -> decode TradeSignalResponse
        |> required "Ok" JD.bool False
        |> required "Message" JD.string ""
        |> required "OrderId" JD.string ""


tradeSignalResponseEncoder : TradeSignalResponse -> JE.Value
tradeSignalResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Ok" JE.bool False v.ok)
        , (requiredFieldEncoder "Message" JE.string "" v.message)
        , (requiredFieldEncoder "OrderId" JE.string "" v.orderId)
        ]
