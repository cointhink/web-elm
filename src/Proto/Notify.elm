module Proto.Notify exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/notify.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias Notify =
    { recipient : String -- 2
    , summary : String -- 3
    , detail : String -- 4
    , action : String -- 5
    }


notifyDecoder : JD.Decoder Notify
notifyDecoder =
    JD.lazy <| \_ -> decode Notify
        |> required "Recipient" JD.string ""
        |> required "Summary" JD.string ""
        |> required "Detail" JD.string ""
        |> required "Action" JD.string ""


notifyEncoder : Notify -> JE.Value
notifyEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Recipient" JE.string "" v.recipient)
        , (requiredFieldEncoder "Summary" JE.string "" v.summary)
        , (requiredFieldEncoder "Detail" JE.string "" v.detail)
        , (requiredFieldEncoder "Action" JE.string "" v.action)
        ]