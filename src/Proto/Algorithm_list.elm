module Proto.Algorithm_list exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/algorithm_list.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias AlgorithmList =
    { filterAccountId : String -- 1
    }


algorithmListDecoder : JD.Decoder AlgorithmList
algorithmListDecoder =
    JD.lazy <| \_ -> decode AlgorithmList
        |> required "filterAccountId" JD.string ""


algorithmListEncoder : AlgorithmList -> JE.Value
algorithmListEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "filterAccountId" JE.string "" v.filterAccountId)
        ]