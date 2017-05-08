-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/account.proto

module Proto.Account exposing (..)

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias Account =
    { email : String -- 1
    , username : String -- 2
    , fullname : String -- 3
    }


accountDecoder : JD.Decoder Account
accountDecoder =
    JD.lazy <| \_ -> decode Account
        |> required "email" JD.string ""
        |> required "username" JD.string ""
        |> required "fullname" JD.string ""


accountEncoder : Account -> JE.Value
accountEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "email" JE.string "" v.email)
        , (requiredFieldEncoder "username" JE.string "" v.username)
        , (requiredFieldEncoder "fullname" JE.string "" v.fullname)
        ]
