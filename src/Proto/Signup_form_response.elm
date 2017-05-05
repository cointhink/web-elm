-- DO NOT EDIT
-- AUTOGENERATED BY THE ELM PROTOCOL BUFFER COMPILER
-- https://github.com/tiziano88/elm-protobuf
-- source file: proto/signup_form_response.proto

module Proto.Signup_form_response exposing (..)

import Protobuf exposing (..)

import Json.Decode as JD
import Json.Encode as JE


type alias SignupFormResponse =
    { ok : Bool -- 1
    }


signupFormResponseDecoder : JD.Decoder SignupFormResponse
signupFormResponseDecoder =
    JD.lazy <| \_ -> decode SignupFormResponse
        |> required "ok" JD.bool False


signupFormResponseEncoder : SignupFormResponse -> JE.Value
signupFormResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "ok" JE.bool False v.ok)
        ]
