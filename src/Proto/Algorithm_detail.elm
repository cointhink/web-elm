module Proto.Algorithm_detail exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/algorithm_detail.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias AlgorithmDetail =
    { algorithmId : String -- 1
    }


algorithmDetailDecoder : JD.Decoder AlgorithmDetail
algorithmDetailDecoder =
    JD.lazy <| \_ -> decode AlgorithmDetail
        |> required "algorithmId" JD.string ""


algorithmDetailEncoder : AlgorithmDetail -> JE.Value
algorithmDetailEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "algorithmId" JE.string "" v.algorithmId)
        ]