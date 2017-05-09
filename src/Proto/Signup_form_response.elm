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
    , reason : SignupFormResponse_Reasons -- 2
    , message : String -- 3
    }


type SignupFormResponse_Reasons
    = SignupFormResponse_EmailAlert -- 0
    | SignupFormResponse_UsernameAlert -- 1


signupFormResponseDecoder : JD.Decoder SignupFormResponse
signupFormResponseDecoder =
    JD.lazy <| \_ -> decode SignupFormResponse
        |> required "ok" JD.bool False
        |> required "Reason" signupFormResponse_ReasonsDecoder signupFormResponse_ReasonsDefault
        |> required "Message" JD.string ""


signupFormResponse_ReasonsDecoder : JD.Decoder SignupFormResponse_Reasons
signupFormResponse_ReasonsDecoder =
    let
        lookup s =
            case s of
                "EMAIL_ALERT" ->
                    SignupFormResponse_EmailAlert

                "USERNAME_ALERT" ->
                    SignupFormResponse_UsernameAlert

                _ ->
                    SignupFormResponse_EmailAlert
    in
        JD.map lookup JD.string


signupFormResponse_ReasonsDefault : SignupFormResponse_Reasons
signupFormResponse_ReasonsDefault = SignupFormResponse_EmailAlert


signupFormResponseEncoder : SignupFormResponse -> JE.Value
signupFormResponseEncoder v =
    JE.object <| List.filterMap identity <|
        [ (requiredFieldEncoder "ok" JE.bool False v.ok)
        , (requiredFieldEncoder "Reason" signupFormResponse_ReasonsEncoder signupFormResponse_ReasonsDefault v.reason)
        , (requiredFieldEncoder "Message" JE.string "" v.message)
        ]


signupFormResponse_ReasonsEncoder : SignupFormResponse_Reasons -> JE.Value
signupFormResponse_ReasonsEncoder v =
    let
        lookup s =
            case s of
                SignupFormResponse_EmailAlert ->
                    "EMAIL_ALERT"

                SignupFormResponse_UsernameAlert ->
                    "USERNAME_ALERT"

    in
        JE.string <| lookup v
