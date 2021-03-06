module Proto.Session_create_response exposing (..)

-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/session_create_response.proto

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Proto.Account exposing (..)


type alias SessionCreateResponse =
    { ok : Bool -- 1
    , account : Maybe Account -- 2
    }


sessionCreateResponseDecoder : JD.Decoder SessionCreateResponse
sessionCreateResponseDecoder =
    JD.lazy <| \_ -> decode SessionCreateResponse
        |> required "Ok" JD.bool False
        |> optional "Account" accountDecoder


sessionCreateResponseEncoder : SessionCreateResponse -> JE.Value
sessionCreateResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "Ok" JE.bool False v.ok)
        , (optionalEncoder "Account" accountEncoder v.account)
        ]
